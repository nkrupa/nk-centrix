class MemorySummarizer
  def self.summarize_session(session_id)
    entries = MemoryEntry.where(session_id: session_id, summary: false).order(:timestamp)

    return if entries.empty?

    conversation_text = entries.map { |e| "#{e.role.capitalize}: #{e.content}" }.join("\n")

    prompt = <<~PROMPT
      Summarize the following conversation in 1-2 paragraphs. Focus on key topics discussed, decisions made, and anything useful to remember later.

      #{conversation_text}
    PROMPT

    summary_text = call_openai(prompt)

    MemoryEntry.create!(
      session_id: session_id,
      role: "system",
      content: summary_text,
      summary: true,
      timestamp: Time.current,
      embedding: EmbeddingService.embed(summary_text)
    )
  end

  def self.call_openai(prompt)
    uri = URI("https://api.openai.com/v1/chat/completions")
    response = Net::HTTP.post(
      uri,
      {
        model: "gpt-4",
        messages: [
          { role: "system", content: "You are a helpful summarizer." },
          { role: "user", content: prompt }
        ],
        temperature: 0.5
      }.to_json,
      {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{api_token}"
      }
    )
    pp JSON.parse(response.body)
    JSON.parse(response.body).dig("choices", 0, "message", "content")
  end

  def self.api_token
    Rails.application.credentials.openai[:token]
  end

end

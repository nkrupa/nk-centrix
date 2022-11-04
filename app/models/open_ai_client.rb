class OpenAiClient

  def initialize(session_id: nil, client: nil)
    @session_id = session_id
    @client = client
  end

  def models
    client.models.list
  end

  def question(prompt)
    q = format_question(prompt)
    response = client.completions(
      parameters: {
          model: "text-davinci-001",
          max_tokens: 400,
          prompt: q,
          user: user_id
     })
  end

  def chat(prompt)
    response = client.completions(
      parameters: {
        model: "text-davinci-002",
        prompt: prompt,
        temperature: 0.9,
        max_tokens: 200,
        top_p: 1,
        frequency_penalty: 0,
        presence_penalty: 0.6,
        stop: [" Human:", " AI:"]
      })
  end

  # Commands

  def fix_spelling(text)
    response = client.edits(
        parameters: {
            model: "text-davinci-edit-001",
            input: text,
            instruction: "Fix the spelling mistakes",
            user: user_id
        }
    )
  end

  def generate_image!(prompt)
    body = {
      "prompt" => prompt,
      "n" => 1,
      "size" => "256x256",
      "response_format" => "b64_json"
    }
    response = Faraday.post(
      "https://api.openai.com/v1/images/generations",
      body.to_json,
      { "Content-Type" => "application/json",
        "Authorization" => "Bearer #{api_token}" },
    )
    JSON.parse(response.body)

  end


  # Utilities
  def format_question(prompt)
    prompt = prompt.to_s.squish
    if !prompt.last == "?"
      prompt += "?"
    end
    prompt
  end

  attr_reader :session_id

  def user_id
    @user_id ||= [Rails.env, session_id || SecureRandom.uuid].join("-")
  end

  def api_token
    Rails.application.credentials.openai[:token]
  end

  def client
    @client ||= OpenAI::Client.new(access_token: api_token)
  end
end
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

  def client
    @client ||= OpenAI::Client.new(access_token: Rails.application.credentials.openai[:token])
  end
end
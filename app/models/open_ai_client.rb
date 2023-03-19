class OpenAiClient

  def initialize(session_id: nil, client: nil)
    @session_id = session_id
    @client = client
  end

  def models
    client.models.list
  end

  def chat(prompt, messages: [])
    messages.push({ role: "user", content: prompt })
    response = client.chat(
      parameters: {
          model: "gpt-3.5-turbo", # Required.
          messages: messages,#[{ role: "user", content: "Hello!"}], # Required.
          temperature: 0.7,
      })
    pp response
  end

  # Commands

  def generate_image!(prompt)
    body = {
      "prompt" => prompt,
      "n" => 2,
      "size" => "256x256",
      "user" => user_id,
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
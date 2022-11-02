class OpenAiClient

  def models
    client.models.list
  end

  def client
    @client ||= OpenAI::Client.new(access_token: Rails.application.credentials.openai[:token])
  end
end
require 'net/http'
require 'json'

class EmbeddingService
  OPENAI_ENDPOINT = URI("https://api.openai.com/v1/embeddings")

  def self.embed(text)
    response = Net::HTTP.post(
      OPENAI_ENDPOINT,
      { model: "text-embedding-3-small", input: text }.to_json,
      {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{token}"
      }
    )
    JSON.parse(response.body)["data"][0]["embedding"]
  end

  def self.token
    Rails.application.credentials.openai[:token]
  end
end

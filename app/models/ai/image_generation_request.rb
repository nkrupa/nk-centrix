class Ai::ImageGenerationRequest < Ai::Request
  has_many :images, class_name: "Ai::RequestImage", foreign_key: :ai_request_id

  def generate!(prompt)
    client = OpenAiClient.new(session_id: session_id)
    response = client.generate_image!(prompt)
    self.images.create!(request: self, base64: response["data"]["b64_json"])
  end

end

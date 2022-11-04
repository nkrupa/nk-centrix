class Ai::ImageGenerationRequest < Ai::Request
  has_many :images, class_name: "Ai::RequestImage", foreign_key: :ai_request_id

  def generate!(prompt)
    client = OpenAiClient.new(session_id: session_id)
    update!(
      query: prompt,
      full_prompt: prompt
    )
    self.response = client.generate_image!(prompt)

    # request.parse_response
    save!

    response["data"].each do |image_node|
      self.images.create!(request: self, base64: image_node["b64_json"])
    end
  end

end

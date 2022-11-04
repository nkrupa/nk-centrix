class Ai::RequestImage < ApplicationRecord
  belongs_to :request, class_name: "Ai::ImageGenerationRequest", foreign_key: :ai_request_id
end

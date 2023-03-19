class Ai::Request < ApplicationRecord
  validates :session_id, presence: true

  def parse_response
    self.response_text = response["choices"][0]["message"]["content"]
    self.tokens_used = response["usage"]["total_tokens"].to_i
  end
end

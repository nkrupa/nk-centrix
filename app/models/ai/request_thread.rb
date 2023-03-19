class Ai::RequestThread < ApplicationRecord
  has_many :requests, class_name: "Ai::ThreadedRequest", foreign_key: :ai_request_thread_id

  validates :session_id, presence: true

  def first_prompt
    messages.first&.dig("content")
  end

  def add!(text)
    client = OpenAiClient.new(session_id: session_id)
 
    request = self.requests.create!(
      thread: self,
      session_id: session_id || thread.session_id,
      query: text
    )
    request.response = client.chat(text, messages: messages)
    request.parse_response
    request.save!

    # append new message 
    self.messages ||= []
    self.messages << { "role"=>"user", "content"=>text }
    self.messages << request.response["choices"][0]["message"]
    self.save!

    return request
  end


end

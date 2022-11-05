class Ai::RequestThread < ApplicationRecord
  has_many :requests, class_name: "Ai::ThreadedRequest", foreign_key: :ai_request_thread_id

  validates :session_id, presence: true

  def add!(text)
    client = OpenAiClient.new(session_id: session_id)
    prefix = full_text || default_prefix
    prompt = [prefix, "\nHuman: ", text].join("")

    request = self.requests.create!(
      thread: self,
      session_id: session_id || thread.session_id,
      query: text,
      full_prompt: prompt
    )
    request.response = client.chat(prompt)
    request.parse_response
    request.save!

    # conversation = [prompt, "\nAI: ", request.response_text].join("")
    conversation = [prompt, "\nAI:", request.response_text].join("")
    update!(full_text: conversation)
    puts "A) #{request.response_text}"
    return request
  end

  def default_prefix
    "The following is a conversation with an AI assistant. " +
    "The assistant is clever, and friendly.\n" +
    "Human: Hello, who are you?\nAI: I am an AI created by OpenAI. How can I help you today?\n"

    # "The following is a conversation with an AI assistant. " +
    # "The assistant is helpful, creative, clever, and very friendly.\n" +
    # "\nHuman: Hello, who are you?\nAI: I am an AI created by OpenAI. How can I help you today?\n"
  end

end

class Ai::ThreadedRequest < Ai::Request
  belongs_to :thread, class_name: "Ai::RequestThread", foreign_key: :ai_request_thread_id
  belongs_to :previous_request, class_name: "Ai::PreviousRequest", optional: true

end

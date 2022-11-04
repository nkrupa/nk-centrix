class AddAiRequestThreadToAiRequests < ActiveRecord::Migration[7.0]
  def change
    add_reference :ai_requests, :ai_request_thread, type: :uuid, foreign_key: { to_table: :ai_request_threads }
  end
end

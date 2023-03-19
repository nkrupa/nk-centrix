class AddMessagesToAiRequestThreads < ActiveRecord::Migration[7.0]
  def change
    add_column :ai_request_threads, :messages, :jsonb, default: []
  end
end

class AddResponseSecondsToAiRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :ai_requests, :response_seconds, :integer, default: 0
  end
end

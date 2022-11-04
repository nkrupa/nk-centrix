class CreateAiRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :ai_requests, id: :uuid do |t|
      t.string :type
      t.uuid :session_id
      t.text :query
      t.text :full_prompt
      t.jsonb :response, default: {}
      t.text :response_text
      t.integer :tokens_used

      t.timestamps
    end
  end
end

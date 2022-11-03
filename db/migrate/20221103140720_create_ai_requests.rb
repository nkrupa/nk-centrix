class CreateAiRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :ai_requests, id: :uuid do |t|
      t.string :type
      t.uuid :session_id
      t.jsonb :query
      t.jsonb :response, default: {}
      t.text :response_text
      t.integer :tokens

      t.timestamps
    end
  end
end

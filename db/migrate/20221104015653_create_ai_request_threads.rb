class CreateAiRequestThreads < ActiveRecord::Migration[7.0]
  def change
    create_table :ai_request_threads, id: :uuid do |t|
      t.string :session_id

      t.timestamps
    end
  end
end

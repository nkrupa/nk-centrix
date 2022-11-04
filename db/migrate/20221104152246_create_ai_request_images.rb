class CreateAiRequestImages < ActiveRecord::Migration[7.0]
  def change
    create_table :ai_request_images, id: :uuid do |t|
      t.references :ai_request, null: false, foreign_key: { to_table: :ai_requests }, type: :uuid
      t.text :base64

      t.timestamps
    end
  end
end

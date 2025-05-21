class CreateMemoryEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :memory_entries do |t|
      t.text :content
      t.column :embedding, :vector, limit: 1536

      t.timestamps
    end
  end
end

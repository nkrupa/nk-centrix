class AddMetadataToMemoryEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :memory_entries, :role, :string    # e.g. "user", "assistant", "system"
    add_column :memory_entries, :session_id, :string
    add_column :memory_entries, :timestamp, :datetime
  end
end

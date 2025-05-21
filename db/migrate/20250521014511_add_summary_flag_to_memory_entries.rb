class AddSummaryFlagToMemoryEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :memory_entries, :summary, :boolean, default: false
  end
end

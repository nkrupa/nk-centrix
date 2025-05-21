class CreateHelpArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :help_articles do |t|
      t.string :title
      t.text :content
      t.column :embedding, :vector, limit: 1536
      t.string :tags

      t.timestamps
    end
  end
end

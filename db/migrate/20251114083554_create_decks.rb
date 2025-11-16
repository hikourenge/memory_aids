class CreateDecks < ActiveRecord::Migration[8.0]
  def change
    create_table :decks do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.integer :is_public? ,default: 0, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

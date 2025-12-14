class CreateDecksTags < ActiveRecord::Migration[8.0]
  def change
    create_table :decks_tags do |t|
      t.references :deck, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :decks_tags, [ :deck_id, :tag_id ], unique: true
  end
end

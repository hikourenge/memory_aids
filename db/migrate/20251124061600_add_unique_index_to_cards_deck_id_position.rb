class AddUniqueIndexToCardsDeckIdPosition < ActiveRecord::Migration[8.0]
  def change
    add_index :cards, [ :deck_id, :position ], unique: true
  end
end

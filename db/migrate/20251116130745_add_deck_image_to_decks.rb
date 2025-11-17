class AddDeckImageToDecks < ActiveRecord::Migration[8.0]
  def change
    add_column :decks, :deck_image, :string
  end
end

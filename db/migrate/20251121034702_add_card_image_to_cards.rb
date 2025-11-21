class AddCardImageToCards < ActiveRecord::Migration[8.0]
  def change
    add_column :cards, :card_image, :string
  end
end

class CreateHints < ActiveRecord::Migration[8.0]
  def change
    create_table :hints do |t|
      t.references :card, foreign_key: true
      t.text :content, null: false
      t.integer :hint_position, null: false

      t.timestamps
    end
  end
end

class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.references :user, foreign_key: true
      t.references :deck, foreign_key: true
      t.text :question, null: false
      t.text :answer, null: false
      t.integer :position, null: false

      t.timestamps
    end
  end
end

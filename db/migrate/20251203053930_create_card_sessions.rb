class CreateCardSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :card_sessions do |t|
        t.references :play_session, null: false, foreign_key: true
        t.references :card,         null: false, foreign_key: true

        t.boolean :is_correct, null: false
        t.integer :duration_seconds

        t.timestamps
      end

      add_index :card_sessions, [ :play_session_id, :card_id ], unique: true
  end
end

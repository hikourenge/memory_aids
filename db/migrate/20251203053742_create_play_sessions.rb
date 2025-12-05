class CreatePlaySessions < ActiveRecord::Migration[8.0]
  def change
    create_table :play_sessions do |t|
      t.references :deck, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true

      t.integer :mode, null: false, default: 0
      t.integer :correct_count, null: false, default: 0

      t.datetime :started_at, null: false
      t.datetime :ended_at
      t.integer  :total_time_seconds

      t.timestamps
    end
  end
end

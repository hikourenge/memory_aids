class RenameDecksIsPublicToStatus < ActiveRecord::Migration[8.0]
  def up
    # ? を含む識別子は SQL レベルでクォートしてリネームするのが確実
    execute %(ALTER TABLE decks RENAME COLUMN "is_public?" TO status)
  end

  def down
    execute %(ALTER TABLE decks RENAME COLUMN status TO "is_public?")
  end
end

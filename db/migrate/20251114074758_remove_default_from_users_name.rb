class RemoveDefaultFromUsersName < ActiveRecord::Migration[8.0]
  def up
    change_column_default :users, :name, from: "", to: nil
  end
  def down
    change_column_default :users, :name, from: nil, to: ""
  end
end

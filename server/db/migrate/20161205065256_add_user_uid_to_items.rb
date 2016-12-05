class AddUserUidToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :user_uid, :string
  end
end

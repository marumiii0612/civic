class AddAdminToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :admin, :boolean, default: false  #default: falseの追加をお忘れなく!!!
  end
end

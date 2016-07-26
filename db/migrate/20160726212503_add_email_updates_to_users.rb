class AddEmailUpdatesToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :email_updates, :string
  end
end

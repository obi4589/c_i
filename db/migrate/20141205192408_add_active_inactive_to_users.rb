class AddActiveInactiveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active_p, :boolean, :default => true
    add_column :users, :active_c, :boolean, :default => false
  end
end

class AddWednesdayNewsAndSundayNewsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wednesday_news, :string
    add_column :users, :sunday_news, :string
  end
end

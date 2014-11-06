class AddCityStToUsers < ActiveRecord::Migration
  def change
    add_column :users, :city_st, :string
  end
end

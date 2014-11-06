class AddCityStToEvents < ActiveRecord::Migration
  def change
    add_column :events, :city_st, :string
  end
end

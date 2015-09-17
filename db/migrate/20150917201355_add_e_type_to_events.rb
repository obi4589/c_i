class AddETypeToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :e_type, :string
  end
end

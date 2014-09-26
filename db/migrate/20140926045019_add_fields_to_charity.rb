class AddFieldsToCharity < ActiveRecord::Migration
  def change
    add_column :users, :legal_name, :string
    add_column :users, :ein, :string
    add_column :users, :contact_person, :string
    add_column :users, :phone, :string
    add_column :users, :mission, :text
  end
end

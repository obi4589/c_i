class AddCharityNameAndCharityLegalNameToEvents < ActiveRecord::Migration
  def change
    add_column :events, :charity_name, :string
    add_column :events, :charity_legal_name, :string
  end
end

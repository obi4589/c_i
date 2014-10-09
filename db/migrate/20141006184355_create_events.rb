class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :charity_id
      t.string :title
      t.date :start_date
      t.time :start_time
      t.time :end_time
      t.string :location
      t.text :description
      t.string :address_line_1
      t.string :address_line_2
      t.string :zip_code

      t.timestamps
    end
    add_index :events, [:charity_id, :start_date, :start_time]
  end
end

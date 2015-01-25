class ChangeStartTimeAndEndTimeToDatetimeInEvents < ActiveRecord::Migration
  def change 
  	remove_index :events, :column => [:charity_id, :start_date, :start_time]
  	remove_column :events, :start_date, :date
  	remove_column :events, :start_time, :time 
  	remove_column :events, :end_time, :time


  	add_column :events, :start_time, :datetime
  	add_column :events, :end_time, :datetime
  	add_index :events, [:charity_id, :start_time]
  end
end

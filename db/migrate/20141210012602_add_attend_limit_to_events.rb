class AddAttendLimitToEvents < ActiveRecord::Migration
  def change
    add_column :events, :attend_limit, :integer
  end
end

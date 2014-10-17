class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :philanthropist_id
      t.integer :event_id

      t.timestamps
    end
    add_index :attendances, :philanthropist_id
    add_index :attendances, :event_id
    add_index :attendances, [:philanthropist_id, :event_id], unique: true
  end
end

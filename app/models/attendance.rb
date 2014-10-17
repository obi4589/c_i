class Attendance < ActiveRecord::Base
	belongs_to :philanthropist
	belongs_to :event
	
	validates :philanthropist_id, presence: true
	validates :event_id, presence: true
end

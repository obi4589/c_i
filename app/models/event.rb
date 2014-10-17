class Event < ActiveRecord::Base
	belongs_to :charity 
	
	has_many :attendances, dependent: :destroy
	has_many :philanthropists, through: :attendances

	validates :charity_id, presence: true
	validates :title, presence: true
	validates :start_date, presence: true
	validates :start_time, presence: true
	validates :end_time, presence: true
	#validates :location, presence: true
	validates :description, presence: true
	#validates :address_line_1, presence: true

	#validates :zip_code, presence: true, length: {is: 5}
end

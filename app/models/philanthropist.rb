class Philanthropist < User
	has_many :attendances, dependent: :destroy
	has_many :events, through: :attendances

	validates :zip_code,  presence: true, length: { is: 5 }
	validates :birth_date,  presence: true


#these are the ATTENDANCE methods for philanthropists
	  def attending?(event)
    	attendances.find_by(event_id: event.id)
  	end

  	def attend!(event)
    	attendances.create!(event_id: event.id)
  	end

 	  def no_attend!(event)
    	attendances.find_by(event_id: event.id).destroy
  	end


#these are the HOME FEED methods for philanthropists
    def feed
      Event.joins(:attendances).where("philanthropist_id = ?", id)
    end

    def feed1
      Event.joins(:attendances).from_philanthropists_followed_by_1(self).distinct
    end

    def feed2
      Event.from_charities_followed_by_1(self).distinct
    end


#this is for philanthropist search
    def self.search(query)
    where("name like ? OR email like ? OR city_st like ? OR zip_code like ?", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%") 
  end

end
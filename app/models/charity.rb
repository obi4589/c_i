class Charity < User
	has_many :events, dependent: :destroy

	validates :zip_code,  presence: true, length: { is: 5 }
	validates :legal_name,  presence: true
	validates :ein,  presence: true, length: { is: 9 }, uniqueness: true
	validates :contact_person,  presence: true
	validates :phone,  presence: true, length: { minimum: 10 } 
	validates :mission,  presence: true



#these are the HOME FEED methods for charities
	def feed
    	Event.where("charity_id = ?", id)
  	end

  	def feed1
      Event.joins(:attendances).from_philanthropists_followed_by_2(self).distinct
    end

    def feed2
      Event.from_charities_followed_by_2(self).distinct
    end


#this is for charity search
    def self.search(query)
    where("name like ? OR legal_name like ? OR ein like ? OR mission like ? OR city_st like ? OR zip_code like ? OR email like ?", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%") 
  end
  

end
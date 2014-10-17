class Philanthropist < User
	has_many :attendances, dependent: :destroy
	has_many :events, through: :attendances

	validates :zip_code,  presence: true, length: { is: 5 }
	validates :birth_date,  presence: true



	def attending?(event)
    	attendances.find_by(event_id: event.id)
  	end

  	def attend!(event)
    	attendances.create!(event_id: event.id)
  	end

 	  def no_attend!(event)
    	attendances.find_by(event_id: event.id).destroy
  	end


    def feed
      Event.joins(:attendances).where("philanthropist_id = ?", id)
    end

end
class Philanthropist < User
	validates :zip_code,  presence: true, length: { is: 5 }
	validates :birth_date,  presence: true
end
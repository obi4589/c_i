class Charity < User
	validates :zip_code,  presence: true, length: { is: 5 }
	validates :legal_name,  presence: true
	validates :ein,  presence: true, length: { is: 9 }, uniqueness: true
	validates :contact_person,  presence: true
	validates :phone,  presence: true, length: { minimum: 10 } 
	validates :mission,  presence: true
end
class Event < ActiveRecord::Base
	before_save { self.city_st = zip_code.to_region unless zip_code.blank? }
  before_save { self.city_st = nil if zip_code.blank? }
  before_save { self.charity_name = charity.name unless charity.blank? }
  before_save { self.charity_name = nil if charity.blank? }
  before_save { self.charity_legal_name = charity.legal_name unless charity.blank? }
  before_save { self.charity_legal_name = nil if charity.blank? }   

  include PublicActivity::Common   

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
	#validates :zip_code, presence: true, length: {is: 5}, unless: :zip_code



  #paperclip/imagemagick configuration
  has_attached_file :cover_photo, 
    styles: {
      medium:  '306x221^',
      large: '960x600^'
    }, 
    convert_options: {
      medium: " -gravity center -crop '306x221+0+0'",
      large: " -gravity center -crop '960x600+0+0'"
    }
    validates_attachment_content_type :cover_photo, 
      :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
    validates_attachment_presence :cover_photo



# these are the home feed methods for philanthropists
# Returns events from the users being followed by the given philanthropist.
  def self.from_philanthropists_followed_by_1(user)
    followed_user_ids = "SELECT followable_id FROM follows
                         WHERE follower_id = :user_id"
    where("philanthropist_id IN (#{followed_user_ids}) OR philanthropist_id = :user_id",
          user_id: user.id)
  end

  def self.from_charities_followed_by_1(user)
    followed_user_ids = "SELECT followable_id FROM follows
                         WHERE follower_id = :user_id"
    where("charity_id IN (#{followed_user_ids})",
          user_id: user.id)
  end



# these are the home feed methods for charities
# Returns events from the users being followed by the given charity.
  def self.from_philanthropists_followed_by_2(user)
    followed_user_ids = "SELECT followable_id FROM follows
                         WHERE follower_id = :user_id"
    where("philanthropist_id IN (#{followed_user_ids})",
          user_id: user.id)
  end

  def self.from_charities_followed_by_2(user)
    followed_user_ids = "SELECT followable_id FROM follows
                         WHERE follower_id = :user_id"
    where("charity_id IN (#{followed_user_ids}) OR charity_id = :user_id",
          user_id: user.id)
  end



# this is the method for allowing a current user to see how many of his "follows" are attending a given event
  def follows_at_event(current_user)
      Attendance.follows_attending(self, current_user)
  end




#this is for event search
  def self.search(query)
    where("lower(charity_name) LIKE lower(?) OR  lower(charity_legal_name) LIKE lower(?) OR  lower(city_st) LIKE lower(?) OR  lower(zip_code) LIKE lower(?) OR  lower(title) LIKE lower(?) OR  lower(description) LIKE lower(?)", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%") 
  end

end

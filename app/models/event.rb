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



end

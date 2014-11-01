class Attendance < ActiveRecord::Base
	belongs_to :philanthropist
	belongs_to :event
	
	validates :philanthropist_id, presence: true
	validates :event_id, presence: true






  def self.follows_attending(event, current_user)
    followed_user_ids = "SELECT followable_id FROM follows
                         WHERE follower_id = :current_user_id"
    where("event_id = :event_id AND philanthropist_id IN (#{followed_user_ids})",
          event_id: event.id, current_user_id: current_user.id)
  end






end

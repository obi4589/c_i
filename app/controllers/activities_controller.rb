class ActivitiesController < ApplicationController
  before_action :signed_in_user


  def index
  	followed_user_ids = current_user.follows.map {|x| x.followable_id}
  	@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: followed_user_ids, owner_type: "User").take(50)

    all_users = User.select {|x| x.type != "Superadmin" }.select {|x| x.id != current_user.id }.map { |x| x.id  }
    remaining_users = (all_users - followed_user_ids)
    
    current_coord = Geocoder.coordinates("#{current_user.zip_code}")
    @recommended_users = User.where(id: remaining_users).select {|x| Geocoder::Calculations.distance_between(current_coord, Geocoder.coordinates("#{x.zip_code}")) <= 5}.sort_by(&:name).take(3)
  end


  def me
    follows = Follow.select {|x| x.followable_id == current_user.id }.map {|x| x.id}
    @activities = PublicActivity::Activity.order("created_at desc").where(trackable_id: follows, trackable_type: "Follow").take(50)

    followed_user_ids = current_user.follows.map {|x| x.followable_id}
    all_users = User.select {|x| x.type != "Superadmin" }.select {|x| x.id != current_user.id }.map { |x| x.id  }
    remaining_users = (all_users - followed_user_ids)

    current_coord = Geocoder.coordinates("#{current_user.zip_code}")
    @recommended_users = User.where(id: remaining_users).select {|x| Geocoder::Calculations.distance_between(current_coord, Geocoder.coordinates("#{x.zip_code}")) <= 5}.sort_by(&:name).take(3)
  end


  def suggestions
    followed_user_ids = current_user.follows.map {|x| x.followable_id}
    all_users = User.select {|x| x.type != "Superadmin" }.select {|x| x.id != current_user.id }.map { |x| x.id  }
    remaining_users = (all_users - followed_user_ids)

    current_coord = Geocoder.coordinates("#{current_user.zip_code}")
    @recommended_users = User.where(id: remaining_users).select {|x| Geocoder::Calculations.distance_between(current_coord, Geocoder.coordinates("#{x.zip_code}")) <= 5}.sort_by(&:name).take(90)
  end



private

	    def signed_in_user
	      unless signed_in?
	        store_location
	        redirect_to login_url, notice: "Please sign in."
	      end
	    end


  layout false
end


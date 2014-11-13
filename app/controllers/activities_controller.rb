class ActivitiesController < ApplicationController
  before_action :signed_in_user


  def index
  	followed_user_ids = current_user.follows.map {|x| x.followable_id}
  	@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: followed_user_ids, owner_type: "User").take(50)
  end

  def me
    follows = Follow.select {|x| x.followable_id == current_user.id }.map {|x| x.id}
    @activities = PublicActivity::Activity.order("created_at desc").where(trackable_id: follows, trackable_type: "Follow").take(50)
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


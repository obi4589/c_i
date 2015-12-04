class ActivitiesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user_type, except: [:redir_email_updates, :redir_new_event]

  def haversine(current_user,other)
    lat1 = current_user.zip_code.to_lat.to_f
    lon1 = current_user.zip_code.to_lon.to_f
    lat2 = other.zip_code.to_lat.to_f
    lon2 = other.zip_code.to_lon.to_f
    Haversine.distance(lat1, lon1, lat2, lon2).to_mi <= 10
  end


  def haversine2(current_user,other)
    lat1 = current_user.zip_code.to_lat.to_f
    lon1 = current_user.zip_code.to_lon.to_f
    lat2 = other.zip_code.to_lat.to_f
    lon2 = other.zip_code.to_lon.to_f
    Haversine.distance(lat1, lon1, lat2, lon2).to_mi <= 20
  end


  def index
  	followed_user_ids = current_user.follows.map {|x| x.followable_id}
  	@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: followed_user_ids, owner_type: "User").take(50)

    all_users = User.select {|x| x.type != "Superadmin" }.select {|x| x.id != current_user.id }.map { |x| x.id  }
    remaining_users = (all_users - followed_user_ids)
    
    
    @recommended_users = User.where(id: remaining_users).select {|user| haversine(current_user, user)}.sort_by(&:name).take(3)
  end


  def me
    follows = Follow.select {|x| x.followable_id == current_user.id }.map {|x| x.id}
    @activities = PublicActivity::Activity.order("created_at desc").where(trackable_id: follows, trackable_type: "Follow").take(50)

    followed_user_ids = current_user.follows.map {|x| x.followable_id}
    all_users = User.select {|x| x.type != "Superadmin" }.select {|x| x.id != current_user.id }.map { |x| x.id  }
    remaining_users = (all_users - followed_user_ids)

    @recommended_users = User.where(id: remaining_users).select {|user| haversine(current_user, user)}.sort_by(&:name).take(3)
  end


  def suggestions
    followed_user_ids = current_user.follows.map {|x| x.followable_id}
    all_users = User.select {|x| x.type != "Superadmin" }.select {|x| x.id != current_user.id }.map { |x| x.id  }
    remaining_users = (all_users - followed_user_ids)

    @recommended_users = User.where(id: remaining_users).select {|user| haversine(current_user, user)}.sort_by(&:name).take(90)
  end


  def nearby
    followed_user_ids = current_user.follows.map {|x| x.followable_id}
    follows_p = Philanthropist.where(id: followed_user_ids).map {|x| x.id}
    follows_c = Charity.where(id: followed_user_ids).map {|x| x.id}
    null_events = Attendance.where(philanthropist_id: follows_p).map{|x| x.event_id }.uniq
    my_events = current_user.events.map{|x| x.id}

    events = Event.select{|event| event.zip_code.present?}.select{|event| event.start_time >= (Time.now - 5.hours)}.select {|event| haversine2(current_user, event)}.map{|x| x.id}
    @nearby_events = Event.where(id: events).where.not(charity_id: follows_c).where.not(id: null_events).where.not(id: my_events).sort_by {|x| [x.start_time, x.end_time] }.take(100)
    @months = @nearby_events.map {|x| x.start_time.strftime('%B %Y')}.uniq
  end


  def redir_email_updates
    if current_user.type == 'Charity'
      redirect_to email_updates_charity_path(current_user)
    elsif current_user.type == 'Philanthropist' 
      redirect_to email_updates_philanthropist_path(current_user)
    elsif current_user.type == 'Superadmin' 
      redirect_to current_user
    end
  end


  def redir_new_event
    redirect_to new_event_path
  end



private

	    def signed_in_user
	      unless signed_in?
	        store_location
	        redirect_to login_url, notice: "Please sign in."
	      end
	    end


      def correct_user_type
        redirect_to(request.referrer) unless current_user.type == 'Charity' || current_user.type == 'Philanthropist' 
      end


  layout false
end


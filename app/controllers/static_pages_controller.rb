class StaticPagesController < ApplicationController
  before_action :is_active, only: [:inactive]
  before_action :logged_in, only: [:root, :nj_upcoming, :nj_history]


  def haversine(zip,event)
    lat1 = zip.to_lat.to_f
    lon1 = zip.to_lon.to_f
    lat2 = event.zip_code.to_lat.to_f
    lon2 = event.zip_code.to_lon.to_f
    Haversine.distance(lat1, lon1, lat2, lon2).to_mi <= 20
  end


  def root
    @events = Event.order("RANDOM()").limit(10)
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def help
  end

  def inactive
  end

  def nj_upcoming
    nj_zip = "08901"
    events = Event.select{|event| event.zip_code.present?}.select{|event| event.start_time >= (Time.now - 4.hours)}.select {|event| haversine(nj_zip, event)}.map{|x| x.id}
    @nearby_events = Event.where(id: events).sort_by {|x| [x.start_time, x.end_time] }.take(100)
    @months = @nearby_events.map {|x| x.start_time.strftime('%B %Y')}.uniq
  end

  def nj_history
    nj_zip = "08901"
    events = Event.select{|event| event.zip_code.present?}.select{|event| event.start_time < (Time.now - 4.hours)}.select {|event| haversine(nj_zip, event)}.map{|x| x.id}
    @nearby_events = Event.where(id: events).sort {|x,y| [y.start_time, y.end_time] <=> [x.start_time, x.end_time] }.take(100)
    @months = @nearby_events.map {|x| x.start_time.strftime('%B %Y')}.uniq
  end

 

  private


  # Before filters


      def is_active
        if current_user.type == 'Philanthropist'
          redirect_to(current_user) unless current_user.active_p == false
        elsif current_user.type == 'Charity'
          redirect_to(current_user) unless current_user.active_c == false
        end
      end

      def logged_in
        if signed_in?
          redirect_to(home_philanthropist_path(current_user)) if current_user.type == 'Philanthropist'
          redirect_to(home_charity_path(current_user)) if current_user.type == 'Charity'
          redirect_to(current_user) if current_user.type == 'Superadmin'
        end        
      end


  layout false
end

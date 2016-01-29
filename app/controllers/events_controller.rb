class EventsController < ApplicationController
  before_action :signed_in_user, except: [:show, :go]
  #before_action :correct_user, only: [:edit, :update]
  before_action :correct_user_type, only: [:new]
  before_action :event_exists, only: [:show, :edit, :attendees, :friends]
  before_action :correct_or_sa, only: [:destroy, :edit, :update, :clone]
  before_action :is_active, only: [:new, :create, :edit, :update, :destroy, :clone]

  
  def index
    if params[:search]
      @events = Event.search(params[:search]).select {|x| x.start_time >= (Time.now - 5.hours) }.sort_by {|x| [x.start_time, x.end_time] }.take(30)
      @charities = Charity.search(params[:search]).sort_by(&:name).take(30)
      @philanthropists = Philanthropist.search(params[:search]).sort_by(&:name).take(30)
    else
      @events = Event.all.take(0)
      @charities = Charity.all.take(0)
      @philanthropists = Philanthropist.all.take(0)
    end
  end



  def new
  	@event = current_user.events.build
  end

  def create
  	@event = current_user.events.build(event_params)
  	if @event.save
      @event.create_activity :create, owner: current_user
   		flash[:success] = "Event created!"
   		redirect_to @event
 	  else
   		@feed_items = []
   		render 'new'
 	  end
  end

  def show
  	@event = Event.find(params[:id]) 
    @philanthropist = @event.philanthropists
  end

  def edit
  	@event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      send_update_email
      flash[:success] = "Event updated"
      redirect_to @event
    else
      @feed_items = []
      render 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    send_cancel_email
    @event.destroy
    flash[:success] = "Event deleted."
    redirect_to @event.charity
  end

  def attendees
    @event = Event.find(params[:id]) 
    @attendees = @event.philanthropists.all.sort_by(&:name)
    @friends = @event.follows_at_event(current_user)

    render 'attendees'
  end

  def friends
    @event = Event.find(params[:id]) 
    @attendees = @event.philanthropists.all
    @friends = @event.follows_at_event(current_user).sort{ |a,b| b[:created_at] <=> a[:created_at] }

    render 'friends'
  end


  def go
    keep_page
    redirect_to login_url, notice: "Please sign in."
  end


  def clone
    @event = Event.find(params[:id])
    @new_event = @event.dup
    @new_event.save
    flash[:success] = "Event cloned! Edit your new event and change your cover photo!"
    redirect_to edit_event_path(@new_event)
  end

  




	private
	  	def event_params
	  		params.require(:event).permit(:title, :start_time, :end_time, :location, :description, :address_line_1, :address_line_2, :zip_code, :attend_limit, :cover_photo, :e_type)
	  	end

	    # Before filters


	    def signed_in_user
	      unless signed_in?
	        store_location
	        redirect_to login_url, notice: "Please sign in."
	      end
	    end

	    def correct_user
	    	@event = Event.find(params[:id])
	      redirect_to(@event) unless current_user?(@event.charity)
	    end

	    def correct_user_type
	      redirect_to(current_user) unless current_user.type == 'Charity'
	    end

      def correct_or_sa
        @event = Event.find(params[:id])
        redirect_to(@event) unless current_user?(@event.charity) || current_user.type == "Superadmin"
      end

      def is_active
        if current_user.type == 'Philanthropist'
          redirect_to(inactive_path) unless current_user.active_p == true
        elsif current_user.type == 'Charity'
          redirect_to(inactive_path) unless current_user.active_c == true
        end
      end

      def send_update_email
        if @event.philanthropists.any? && (Time.now - 5.hours) <= @event.start_time
          if @event.previous_changes.include?("location") || @event.previous_changes.include?("address_line_1") || @event.previous_changes.include?("address_line_2") || @event.previous_changes.include?("zip_code") || @event.previous_changes.include?("start_time") || @event.previous_changes.include?("end_time")
            UserMailer.event_update(@event).deliver
          end
        end
      end

      def send_cancel_email
        if @event.philanthropists.any? && (Time.now - 5.hours) <= @event.start_time
          UserMailer.event_cancel(@event).deliver
        end
      end


      def event_exists
        unless Event.exists?(params[:id])
          flash[:success] = "Event no longer exists"
          redirect_to root_url
        end
      end

layout false
end

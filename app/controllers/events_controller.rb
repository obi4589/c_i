class EventsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:edit, :update]
  before_action :correct_user_type, only: [:new]
  before_action :correct_or_sa, only: [:destroy]

  
  def index
    if params[:search]
      @events = Event.search(params[:search]).select {|x| x.start_date >= Date.today }.sort_by {|x| [x.start_date, x.start_time, x.end_time] }.take(30)
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
      flash[:success] = "Event updated"
      redirect_to @event
    else
      @feed_items = []
      render 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
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

  




	private
	  	def event_params
	  		params.require(:event).permit(:title, :start_date, :start_time, :end_time, :location, :description, :address_line_1, :address_line_2, :zip_code)
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

layout false
end

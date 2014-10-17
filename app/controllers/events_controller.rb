class EventsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:edit, :update]
  before_action :correct_user_type, only: [:new]
  before_action :correct_or_sa, only: [:destroy]

  def new
  	@event = current_user.events.build
  end

  def create
  	@event = current_user.events.build(event_params)
  	if @event.save
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
      render 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:success] = "Event deleted."
    redirect_to @event.charity
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

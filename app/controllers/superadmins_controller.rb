class SuperadminsController < ApplicationController
	before_action :signed_in_user
	before_action :correct_user
	before_action :correct_user_type



	def index1
		@superadmin = Superadmin.find(params[:id])
		@users = User.all
		@philanthropists = Philanthropist.all
		@superadmins = Superadmin.all
		@events = Event.all
		render 'index1'
	end

	def index2
		@superadmin = Superadmin.find(params[:id])
		@users = User.all
		@charities = Charity.all
		@superadmins = Superadmin.all
		@events = Event.all
		render 'index2'
	end




	def show
		@superadmin = Superadmin.find(params[:id])
		@events = Event.all
		@user = @superadmin
	end


	private


	# Before filters


	    def signed_in_user
	      unless signed_in?
	        store_location
	        redirect_to login_url, notice: "Please sign in."
	      end
	    end

	    def correct_user
	      @superadmin = Superadmin.find(params[:id])
	      redirect_to(current_user) unless current_user?(@superadmin)
	    end

	    def correct_user_type
	      redirect_to(current_user) unless current_user.type == 'Superadmin'
	    end

layout false

end

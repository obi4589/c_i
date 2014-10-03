class SuperadminsController < ApplicationController
	before_action :signed_in_user
	before_action :correct_user,  only: [:show]


	def index
		@users = User.all
		@philanthropists = Philanthropist.all
		@superadmins = Superadmin.all
	end

	def index2
		@users = User.all
		@charities = Charity.all
		@superadmins = Superadmin.all
	end




	def show
		@superadmin = Superadmin.find(params[:id])
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

layout false

end

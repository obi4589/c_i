class CharitiesController < ApplicationController
  def new
  	@charity = Charity.new
  end

  def create
    @charity = Charity.new(charity_params)   
    if @charity.save
        flash[:success] = "Welcome to Cherry Ivy"
        redirect_to @charity
    else
      render 'new'
    end    
  end

  def show
  	@charity = Charity.find(params[:id]) 
  end



  private
  	def charity_params
  		params.require(:charity).permit(:legal_name, :name, :ein, :zip_code, :contact_person, :email, :phone, :password, :password_confirmation, :mission)
  	end

  layout false
end

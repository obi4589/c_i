class PhilanthropistsController < ApplicationController
  def new
  	@philanthropist = Philanthropist.new
  end

  def create
    @philanthropist = Philanthropist.new(philanthropist_params)    
    if @philanthropist.save
        flash[:success] = "Welcome to Cherry Ivy"
        redirect_to @philanthropist
    else
      render 'new'
    end    
  end

  def show
  	@philanthropist = Philanthropist.find(params[:id]) 
  end

  

  private
  	def philanthropist_params
  		params.require(:philanthropist).permit(:name, :email, :zip_code, :birth_date, :password, :password_confirmation )
  	end

  layout false
end

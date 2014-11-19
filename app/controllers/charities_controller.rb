class CharitiesController < ApplicationController
  before_action :signed_in_user, only: [:show, :edit, :update, :home, :followers, :following, :about, :history]
  before_action :correct_user,   only: [:edit, :update, :home]
  before_action :is_superadmin?, only: [:destroy]


  def new
  	@charity = Charity.new
  end



  def create
    @charity = Charity.new(charity_params)   
    if @charity.save
        sign_in @charity
        flash[:success] = "Welcome to Cherry Ivy"
        redirect_to suggestions_activities_path
        #redirect_to home_charity_path(@charity)
    else
      render 'new'
    end    
  end



  def show
  	@charity = Charity.find(params[:id]) 
    events = @charity.events.all.sort_by {|x| [x.start_date, x.start_time, x.end_time] }
    @final_feed = events.select {|x| x.start_date >= Date.today }.take(100)
    @months = @final_feed.map {|x| x.start_date.strftime('%B %Y')}.uniq
    @user = @charity
  end

 

  def edit
    @charity = Charity.find(params[:id])
  end


  def update
    @charity = Charity.find(params[:id])
    if @charity.update_attributes(charity_params)
      flash[:success] = "Profile updated"
      redirect_to @charity
    else
      render 'edit'
    end
  end

  def destroy
    keep_page
    Charity.find(params[:id]).destroy
    flash[:success] = "Charity deleted."
    redirect_back_or index1_superadmin_path(current_user)
  end

  

  def home
    @charity = Charity.find(params[:id])
    #@feed_items = current_user.feed.all
    feed1 = current_user.feed1.all
    feed2 = current_user.feed2.all
    total_feed = feed1 + feed2
    feed_items = total_feed.uniq.sort_by {|x| [x.start_date, x.start_time, x.end_time] }
    @final_feed = feed_items.select {|x| x.start_date >= Date.today }.take(100)
    @months = @final_feed.map {|x| x.start_date.strftime('%B %Y')}.uniq
  end
 

  def followers
    @charity = Charity.find(params[:id])
    @user = @charity
    @followers = Follow.where(followable_id: @user.id).sort{ |a,b| b[:created_at] <=> a[:created_at] }
    #@followers = @user.followers.sort_by(&:name)
  end

  def following
    @charity = Charity.find(params[:id])
    @user = @charity
    @following = @user.all_follows.sort{ |a,b| b[:created_at] <=> a[:created_at] }
  end

  def about
    @charity = Charity.find(params[:id])
    @user = @charity
    render 'charity_about'
  end

  def history
    @charity = Charity.find(params[:id])
    events = @charity.events.all.sort {|x,y| [y.start_date, y.start_time, y.end_time] <=> [x.start_date, x.start_time, x.end_time] }
    @final_feed = events.select {|x| x.start_date < Date.today }.take(100)
    @months = @final_feed.map {|x| x.start_date.strftime('%B %Y')}.uniq
    @user = @charity
  end



  private
  	def charity_params
  		params.require(:charity).permit(:legal_name, :name, :ein, :zip_code, :contact_person, :email, :phone, :password, :password_confirmation, :mission)
  	end


    # Before filters


    def signed_in_user
      unless signed_in?
        store_location
        redirect_to login_url, notice: "Please sign in."
      end
    end

    def correct_user
      @charity = Charity.find(params[:id])
      redirect_to(@charity) unless current_user?(@charity)
    end





  layout false
end

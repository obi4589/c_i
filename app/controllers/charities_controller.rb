class CharitiesController < ApplicationController
  before_action :signed_in_user, only: [:show, :edit, :update, :home, :followers, :following, :about, :history, :active, :no_avatar, :change_password, :update_password]
  before_action :correct_user,   only: [:edit, :update, :home, :no_avatar, :change_password, :update_password]
  before_action :is_superadmin?, only: [:destroy, :active]
  before_action :logged_in, only: [:new]


  def new
  	@charity = Charity.new
  end



  def create
    @charity = Charity.new(charity_params)   
    if @charity.save
        UserMailer.welcome_email(@charity).deliver
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
    events = @charity.events.all.sort_by {|x| [x.start_time, x.end_time] }
    @final_feed = events.select {|x| x.start_time >= (Time.now - 5.hours)}.take(100)
    @months = @final_feed.map {|x| x.start_time.strftime('%B %Y')}.uniq
    @user = @charity
  end

 

  def edit
    @charity = Charity.find(params[:id])
  end


  def update
    @charity = Charity.find(params[:id])
    if @charity.update_attributes(charity_params)
      flash[:success] = "Profile updated"
      redirect_to edit_charity_path
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
    feed_items = total_feed.uniq.sort_by {|x| [x.start_time, x.end_time] }
    @final_feed = feed_items.select {|x| x.start_time >= (Time.now - 5.hours)}.take(100)
    @months = @final_feed.map {|x| x.start_time.strftime('%B %Y')}.uniq
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
    events = @charity.events.all.sort {|x,y| [y.start_time, y.end_time] <=> [x.start_time, x.end_time] }
    @final_feed = events.select {|x| x.start_time < (Time.now - 5.hours)}.take(100)
    @months = @final_feed.map {|x| x.start_time.strftime('%B %Y')}.uniq
    @user = @charity
  end


  def active
    @charity = Charity.find(params[:id])
    if @charity.active_c? 
      @charity.update_attribute(:active_c, false)
      redirect_to request.referrer 
    else
      @charity.update_attribute(:active_c, true)
      UserMailer.active_email(@charity).deliver
      redirect_to request.referrer 
    end
  end


  def no_avatar
    @charity = Charity.find(params[:id])
    @charity.update_attribute(:avatar, nil)
    redirect_to request.referrer 
  end


  def change_password
    @charity = Charity.find(params[:id])
  end


  def update_password
    @charity = Charity.find(params[:id])
    if params[:charity][:password].present?
      if @charity.update_attributes(charity_params)
        flash[:success] = "Password updated"
        redirect_to change_password_charity_path
      else
       render 'change_password'
      end
    else
      flash.now[:error] = "Please enter password"
      render 'change_password'
    end
  end



  private
  	def charity_params
  		params.require(:charity).permit(:legal_name, :name, :ein, :zip_code, :contact_person, :email, :phone, :password, :password_confirmation, :mission, :avatar)
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

    def logged_in
      if signed_in?
        redirect_to(home_philanthropist_path(current_user)) if current_user.type == 'Philanthropist'
        redirect_to(home_charity_path(current_user)) if current_user.type == 'Charity'
        redirect_to(current_user) if current_user.type == 'Superadmin'
      end        
    end





  layout false
end

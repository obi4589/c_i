class StaticPagesController < ApplicationController
  before_action :is_active, only: [:inactive]
  before_action :logged_in, only: [:root]

  def root
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

class StaticPagesController < ApplicationController
  before_action :is_active, only: [:inactive]

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


  layout false
end

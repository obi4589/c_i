class AttendancesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user_type
  before_action :is_active

  def create
    @event = Event.find(params[:attendance][:event_id])
    current_user.attend!(@event)
    respond_to do |format|
      format.html { redirect_to @event }
      format.js
    end
    @attendance = Attendance.find_by(philanthropist_id: current_user.id, event_id: @event.id) 
    @attendance.create_activity :create, owner: current_user 

    UserMailer.event_confirm(@event, current_user).deliver
    UserMailer.new_attendee(@event, current_user).deliver
  end

  def destroy
    @event = Attendance.find(params[:id]).event
    current_user.no_attend!(@event)
    respond_to do |format|
      format.html { redirect_to @event }
      format.js
    end

    UserMailer.attendee_cancel(@event, current_user).deliver
  end

  private


  # Before filters


      def signed_in_user
        unless signed_in?
          store_location
          redirect_to login_url, notice: "Please sign in."
        end
      end

      def correct_user_type
        redirect_to(current_user) unless current_user.type == 'Philanthropist'
      end

      def is_active
        if current_user.type == 'Philanthropist'
          redirect_to(inactive_path) unless current_user.active_p == true
        elsif current_user.type == 'Charity'
          redirect_to(inactive_path) unless current_user.active_c == true
        end
      end
end
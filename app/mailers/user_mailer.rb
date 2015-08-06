class UserMailer < ActionMailer::Base
  default from: "Cherry Ivy <noreply@cherryivy.com>"

  def welcome_email_p(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Cherry Ivy!')
  end

  def welcome_email_c(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Cherry Ivy!')
  end

  def password_reset(user)
  	@user = user
  	mail(to: @user.email, subject: 'Password Reset')
  end

  def active_email(user)
  	@user = user
  	mail(to: @user.email, subject: 'Active Account')
  end

  def event_confirm(event, user)
    @event = event
    @user = user
    mail(to: @user.email, subject: "See You Soon: #{@event.title}!")
  end

  def event_cancel(event)
    @event = event
    emails = @event.philanthropists.map {|user| user.email}
    mail(bcc: emails, subject: "Event Cancelled: #{@event.title}")
  end

  def event_update(event)
    @event = event
    emails = @event.philanthropists.map {|user| user.email}
    mail(bcc: emails, subject: "Event Update: #{@event.title}")
  end

  def event_one_day_reminder_email(event)
    @event = event
    emails = @event.philanthropists.map {|user| user.email}
    mail(bcc: emails, subject: "Event Tomorrow: #{@event.title}!")
  end

end

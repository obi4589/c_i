desc "This task is called by the Heroku scheduler add-on"
task :event_reminder => :environment do
  puts "Sending event reminders..."
  Event.one_day_reminder
  puts "Emails sent!"
end
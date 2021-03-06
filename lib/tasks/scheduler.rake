desc "This task is called by the Heroku scheduler add-on"
task :event_reminder => :environment do
  puts "Sending event reminders..."
  Event.one_day_reminder
  Event.one_day_reminder_org
  puts "Emails sent!"
end

task :wed_news_ny => :environment do
	if (Time.now - 4.hours).wednesday?
	  puts "Sending wednesday newsletter..."
	  User.whats_new_wednesday_ny
	  puts "Newsletter sent!"
	end
end

task :sun_news_ny => :environment do
	if (Time.now - 4.hours).sunday?
	  puts "Sending sunday newsletter..."
	  User.this_week_sunday_ny
	  puts "Newsletter sent!"
	end
end
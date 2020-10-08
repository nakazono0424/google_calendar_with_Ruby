# coding: utf-8
require File.dirname(__FILE__) + "/lib/google_calendar_method"
require 'date'

calmana = Calmana.new

if ARGV[0].nil?
  exit
else
  command = ARGV[0]
  
  case command
  # Usage: bundle exec ruby main.rb show_events CALENDAR_ID
  when "show_events" then
    if ARGV[1]
      calendar_id = ARGV[1]
      calmana.show_events(calendar_id)
    else
      puts("カレンダIDを指定してください")
    end

  # Usage: bundle exec ruby main.rb delete CALENDAR_ID EVENT_ID
  when "delete" then
    if ARGV.size() == 3
      calendar_id = ARGV[1]
      event_id = ARGV[2]
      calmana.delete_event(calendar_id, event_id)
    else
      puts("カレンダIDとイベントIDを指定してください")
    end

  # Usage: bundle exec ruby main.rb calendars
  when "calendars" then
    calmana.get_calendar

  # Usage: bundle exec ruby main.rb CALENDAR_ID TITLE START END
  when "post_event" then
    calendar_id = ARGV[1]
    title = ARGV[2]
    start_date = Date.strptime(ARGV[3], '%Y-%m-%d')
    end_date = Date.strptime(ARGV[4], '%Y-%m-%d')
    
    calmana.post_event(calendar_id, title, start_date, end_date )

  else
    puts("定義されていないコマンドです")
  end
end

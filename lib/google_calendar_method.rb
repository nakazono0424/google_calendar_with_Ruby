# coding: utf-8
require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "date"
require "fileutils"

class Calmana
  
  OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
  APPLICATION_NAME = "Google Calendar API Ruby Quickstart".freeze
  CREDENTIALS_PATH = "credentials.json".freeze
  # The file token.yaml stores the user's access and refresh tokens, and is
  # created automatically when the authorization flow completes for the first
  # time.
  TOKEN_PATH = "token.yaml".freeze
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_EVENTS
  
  def initialize
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize
  end

  def authorize
    client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
    token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    user_id = "default"
    credentials = authorizer.get_credentials user_id
    if credentials.nil?
      url = authorizer.get_authorization_url base_url: OOB_URI
      puts "Open the following URL in the browser and enter the " \
           "resulting code after authorization:\n" + url
      code = STDIN.gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
      puts "Authorize Success!"
    end
    credentials
  end
  
  def delete_event(calendar_id, event_id)
    begin
      @service.delete_event(calendar_id, event_id)
      puts("Success delete {}", event_id)
    rescue
      puts("Error")
    end
  end

  def get_calendar
    page_token = nil
    begin
      response = @service.list_calendar_lists(page_token: page_token)
      response.items.each do |e|
        print "CALENDAR NAME: " + e.summary + "\n"
        print "CALENDAR ID  : " + e.id + "\n"
        print "\n"
      end
      if response.next_page_token != page_token
        page_token = response.next_page_token
      else
        page_token = nil
      end
    end while !page_token.nil?
  end

  def show_events(calendar_id)
    page_token = nil
    begin
      response = @service.list_events(calendar_id,
                                      page_token: page_token,
                                      order_by: "starttime",
                                      single_events: true)
      response.items.each do |e|
        begin 
          if e.start.date
            puts e.summary
            puts e.start.date
            puts e.extended_properties.private["recurrence_name"]
          else e.start.date_time
            puts e.summary
            puts e.start.date_time.to_date
            puts e.extended_properties.private["recurrence_name"]
          end
        rescue
          next
        end
      end
      if response.next_page_token != page_token
        page_token = response.next_page_token
      else
        page_token = nil
      end
    end while !page_token.nil?
  end

  def post_event(calendar_id, title, start_date, end_date)
    event = Google::Apis::CalendarV3::Event.new(
      summary: title,
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date: start_date,
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date: end_date,
      ),
      extended_properties: Google::Apis::CalendarV3::Event::ExtendedProperties.new(
        private: {
          recurrence_name: title
        }
      )
    )
    result = @service.insert_event(calendar_id, event)
    puts "Event created: #{result.html_link}"
  end
end

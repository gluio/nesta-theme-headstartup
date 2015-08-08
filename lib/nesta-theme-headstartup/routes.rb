require 'mailchimp'
require 'waitlisted'
if ENV["WAITLISTED_DOMAIN"]
  Waitlisted.configure do |config|
   config.url = "https://#{ENV["WAITLISTED_DOMAIN"]}"
  end
end
module Nesta
  module Theme
    module Headstartup
      module Routes
        def self.included(app)
          app.instance_eval do
            post '/sign-up' do
              if params[:email] && params[:email] != ""
                if ENV["MAILCHIMP_LIST_ID"] && ENV["MAILCHIMP_API_KEY"]
                  begin
                    @mailchimp = Mailchimp::API.new(ENV["MAILCHIMP_API_KEY"])
                    @mailchimp.lists.subscribe(ENV["MAILCHIMP_LIST_ID"], email: params[:email])
                  rescue Mailchimp::Error => ex
                    flash[:error] = ex.message
                    redirect back
                  end
                end
                if ENV["WAITLISTED_DOMAIN"]
                  @reservation = Waitlisted::Reservation.create(email: params[:email])
                end
                haml :signup_thanks, layout: :layout
              else
                redirect back
              end
            end
          end
        end
      end
    end
  end
end

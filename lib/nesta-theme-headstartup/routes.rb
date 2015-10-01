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
          if ENV['WAITLISTED_DOMAIN']
            app.instance_eval do
              get '/waitlist' do
                @title = "You're almost in..."
                if ref_link = waitlisted_signup_page(params[:refcode])
                  flash.now[:success] = <<-EOS
                    You've received a special referral link that will allow you and your
                    friend to jump the queue and get early access.<br/>
                    <a href="#{ref_link}">Click here to take advantage of it now</a>.
                  EOS
                end
                @page = Nesta::Page.find_by_path('/')
                haml :hero
              end
            end
          end
          app.instance_eval do
            post '/sign-up' do
              @title = "One more thing..."
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
                  begin
                    @reservation = Waitlisted::Reservation.create(email: params[:email])
                  rescue StandardError => ex
                    raise if ex.message != "email has already been taken"
                    flash[:success] = "You're already on the list!"
                    redirect back
                  end
                end
                haml :signup_thanks, layout: :bare
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

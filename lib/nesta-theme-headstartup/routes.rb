require 'mailchimp'
module Nesta
  module Theme
    module Headstartup
      module Routes
        def self.included(app)
          app.instance_eval do
            post '/sign-up' do
              if params[:email] && params[:email] != ""
                begin
                  mailchimp = Mailchimp::API.new(ENV["MAILCHIMP_API_KEY"])
                  mailchimp.lists.subscribe(ENV["MAILCHIMP_LIST_ID"], email: params[:email])
                  haml :signup_thanks, layout: :layout
                rescue Mailchimp::Error => ex
                  flash[:error] = ex.message
                  redirect back
                end
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

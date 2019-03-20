if ENV["DATABASE_URL"]
  require "nesta-theme-headstartup/models/person"
end
module Nesta
  module Theme
    module Headstartup
      module Routes
        def self.included(app)
          app.instance_eval do
            before do
              session[:referral] ||= {}
              session[:referral][:medium] ||= params['utm_medium']
              session[:referral][:source] ||= params['utm_source'] || params['ref']
              session[:referral][:campaign] ||= params['utm_campaign']
              session[:referral][:term] ||= params['utm_term']
              session[:referral][:content] ||= params['utm_content']
              session[:referral][:referring_url] ||= request.referer
              session[:referral][:entry_url] ||= request.url
              if session[:person_id]
                @person = Person[uuid: session[:person_id]]
              end
            end

            post '/sign-up' do
              begin
                @title = "One more thing..."
                @person = Person.create_with_analytics(params[:email], session)
                session[:person_id] = @person.uuid
              rescue Sequel::UniqueConstraintViolation
              end
              haml :signup_thanks, layout: :bare
            end
          end
        end
      end
    end
  end
end

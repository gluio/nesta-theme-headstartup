if ENV["DATABASE_URL"]
  require "nesta-theme-headstartup/models/person"
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
          if ENV['WAITLISTED_API_PASSWORD']
            app.instance_eval do
              post "/waitlist/#{ENV['WAITLISTED_API_PASSWORD']}" do
                if ENV['DATABASE_URL']
                  attrs = Yajl::Parser.parse(request.body.read)
                  if attrs['event'] == 'reservation_activated'
                    person = Person.find_or_create(email: attrs['reservation_email'])
                    person.referral_source ||= attrs['reservation_referred_by']
                    person.referral_campaign ||= 'prelaunch'
                    person.referral_medium ||= 'waitlisted.co'
                    person.save
                    person.activate_waitlist! if person.respond_to?(:activate_waitlist!)
                  end
                  'ok'
                end
              end
            end
          end
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

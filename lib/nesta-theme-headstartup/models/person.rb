require 'mailchimp'
require 'sequel'
if ENV["WAITLISTED_DOMAIN"]
  require 'waitlisted'
  Waitlisted.configure do |config|
   config.url = "https://#{ENV["WAITLISTED_DOMAIN"]}"
  end
end
class Person < Sequel::Model
  set_primary_key :uuid
  plugin :whitelist_security
  set_allowed_columns :email,
    :referral_medium, :referral_source, :referral_campaign, :referral_term,
    :referral_content, :referral_referring_url, :referral_entry_url


  EXTERNAL_SERVICES = [
    :mailchimp,
    :waitlisted
  ]

  def self.create_with_analytics(email, data)
    attrs = { email: email }
    data[:referral].each do |field, value|
      attrs["referral_#{field}".to_sym] = value
    end
    person = create(attrs)
  end

  def after_create
    super
    db.after_commit do
      EXTERNAL_SERVICES.each do |service|
        send("#{service}_sync".to_sym)
      end
    end
  end


  def mailchimp_sync
    return unless ENV['MAILCHIMP_LIST_ID'] && ENV['MAILCHIMP_API_KEY']
    mailchimp = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
    mailchimp.lists.subscribe(ENV['MAILCHIMP_LIST_ID'], email: email)
  end

  def waitlisted_sync
    return unless ENV['WAITLISTED_DOMAIN']
    Waitlisted::Reservation.create(email: email)
  end
end

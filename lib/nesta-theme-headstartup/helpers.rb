require 'uri'
module Nesta
  module Theme
    module Headstartup
      module Helpers
        def twitter_handle
          Nesta::Config.fetch("twitter", nil)
        end

        def facebook_page
          Nesta::Config.fetch("facebook", nil)
        end

        def cta_class
          classes = []
          classes << 'join-waitlist' if ENV['WAITLISTED_DOMAIN']
          classes.join(' ')
        end

        def waitlisted_affiliate_link(reservation)
          parts = [
            'https://',
            ENV['WAITLISTED_DOMAIN'],
            '/?refcode=',
            reservation.affiliate]
          URI.escape(parts.join)
        end

        def waitlisted_twitter_share(reservation, text)
          parts = [
            'https://twitter.com/share?url=',
            waitlisted_affiliate_link(reservation),
            '&text=',
            URI.escape(text)].join
        end

        def waitlisted_facebook_share(reservation, text)
          parts = [
            'https://www.facebook.com/dialog/feed?',
            'app_id=660780480720000',
            '&display=popup',
            '&caption=',
            URI.escape(text),
            '&link=',
            waitlisted_affiliate_link(reservation),
            '&redirect_uri=',
            URI.escape('https://www.waitlisted.co/social/fb')].join
        end
      end
    end
  end
end

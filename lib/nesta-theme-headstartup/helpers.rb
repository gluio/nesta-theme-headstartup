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
            'https$3A%2F%2F',
            ENV['WAITLISTED_DOMAIN'],
            '%2F%3Frefcode%3D',
            reservation.affiliate].join
        end
        def waitlisted_twitter_share(reservation, text)
          parts = [
            'https://twitter.com/share?url=',
            waitlisted_affiliate_link(reservation),
            '&text=',
            text].join
        end

        def waitlisted_facebook_share(reservation, text)
          parts = [
            'https://www.facebook.com/dialog/feed?app_id=660780480720000&display=popup&caption=',
            text,
            '&link=',
            waitlisted_affiliate_link(reservation),
            '&redirect_uri=https%3A%2F%2Fcontentfocus.io'].join
        end
      end
    end
  end
end

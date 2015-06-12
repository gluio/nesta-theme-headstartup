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

        def flagged_classes
          classes = [@body_class]
          if @page
            classes << "landing-page" if @page.flagged_as? "landing-page"
            classes << "bare" if @page.flagged_as? "sign-up"
          end
          classes.uniq.join(" ")
        end
      end
    end
  end
end

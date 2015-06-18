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
      end
    end
  end
end

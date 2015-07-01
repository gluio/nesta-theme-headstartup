require "nesta-contentfocus-extensions"
require "nesta-theme-headstartup/version"
require "nesta-theme-headstartup/app"

module Nesta
  module Theme
    module Headstartup
    end
  end
end

base_path = File.expand_path("../assets", File.dirname(__FILE__))
Nesta::Theme.register(:headstartup, { base: base_path })

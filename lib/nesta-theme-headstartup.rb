require "nesta-contentfocus-extensions"
require "nesta-theme-headstartup/version"
require "nesta-theme-headstartup/app"

module Nesta
  module Theme
    module Headstartup
    end
  end
end

asset_path = File.expand_path("../assets", File.dirname(__FILE__))
view_path = File.expand_path(asset_path + "/views")
stylesheet_path = File.expand_path(asset_path + "/stylesheets")
Nesta::Theme.register(:headstartup, { views: view_path, styles: stylesheet_path })

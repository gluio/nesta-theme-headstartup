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
stylesheet_path = File.expand_path(base_path + "/stylesheets")
Nesta::ContentFocus::Paths.add_view_path(view_path)
Nesta::ContentFocus::Paths.add_view_path(File.expand_path(view_path + "/headstartup"))
Nesta::ContentFocus::Paths.add_sass_path(stylesheet_path)

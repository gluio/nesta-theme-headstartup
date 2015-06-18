require "nesta-contentfocus-extensions"
require "nesta-theme-headstartup/version"
require "nesta-theme-headstartup/app"

module Nesta
  module Theme
    module Headstartup
    end
  end
end

base_path = File.dirname(__FILE__) + "/.."
Nesta::ContentFocus::Paths.add_public_path(File.expand_path(base_path + "/public"))
Nesta::ContentFocus::Paths.add_public_path(File.expand_path(base_path + "/public/headstartup"))
Nesta::ContentFocus::Paths.add_view_path(File.expand_path(base_path + "/views"))
Nesta::ContentFocus::Paths.add_view_path(File.expand_path(base_path + "/views/headstartup"))

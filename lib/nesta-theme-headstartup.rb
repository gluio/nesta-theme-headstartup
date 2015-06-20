require "nesta-contentfocus-extensions"
require "nesta-theme-headstartup/version"
require "nesta-theme-headstartup/app"

module Nesta
  module Theme
    module Headstartup
    end
  end
end

base_path = File.expand_path("..", File.dirname(__FILE__))
view_path = File.expand_path(base_path + "/views")
# TODO: Reload Sass loadpaths if this is already set
STDOUT.puts("Headstartup: #{view_path}")
ENV["SASS_PATH"] = [ENV["SASS_PATH"], view_path].compact.join(File::PATH_SEPARATOR)
Nesta::ContentFocus::Paths.add_public_path(File.expand_path(base_path + "/public"))
Nesta::ContentFocus::Paths.add_public_path(File.expand_path(base_path + "/public/headstartup"))
Nesta::ContentFocus::Paths.add_view_path(view_path)
Nesta::ContentFocus::Paths.add_view_path(File.expand_path(view_path + "/headstartup"))

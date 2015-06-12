require "bourbon"
require "neat"
require 'sinatra/flash'
require 'nesta/app'
require "nesta-theme-headstartup/helpers"
require "nesta-theme-headstartup/page"
require "nesta-theme-headstartup/routes"

module Nesta
  class App
    register Sinatra::Flash
    helpers Nesta::Theme::Headstartup::Helpers
    include Nesta::Theme::Headstartup::Routes
  end
end

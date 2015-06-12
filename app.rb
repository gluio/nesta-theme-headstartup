require 'headstartup'
require 'mailchimp'
require 'sinatra/flash'
require 'nesta/config'
require 'nesta/models'
require 'nesta/overrides'
require 'nesta/app'
module Nesta
  class Nesta::Config
    def self.landing_page_path(basename = nil)
      get_path(File.join(content_path, "landing-pages"), basename)
    end
  end

  class Nesta::Page
    def landing_page?
      flagged_as?("landing-page")
    end

    def hero_copy?
      landing_page? && hero_call_to_action
    end

    alias_method :pre_headstartup_to_html, :to_html
    def to_html(scope = Object.new)
      if hero_copy?
        convert_to_html(@format, scope, strip_artifacts(markup))
      else
        pre_headstartup_to_html(scope)
      end
    end

    def hero_heading
      heading
    end

    def hero_copy
      copy = Tilt[:md].new { remove_last_link(full_hero_copy) }.render
      copy.sub(%r{<p.*?>|</p>}, "")
    end

    def hero_call_to_action_text
      hero_call_to_action.first if hero_copy?
    end

    def hero_call_to_action_target
      hero_call_to_action.last if hero_copy?
    end

    private
    def strip_artifacts(markdown)
      markdown = markdown.sub(/^# .*/, "")
      markdown = markdown.sub(/^[A-Za-z0-9]+.*/, "")
      markdown
    end

    def full_hero_copy
      return @full_hero_copy if @full_hero_copy
      regex = case @format
        when :mdown, :md
          /^([A-Za-z0-9]+.*[\r\n])/
        end
      markup =~ regex
      @full_hero_copy = Regexp.last_match(1)
    end

    def hero_call_to_action
      return @cta if @cta
      matches = full_hero_copy.match(/\[([^\]]*?)\]\(([^\)]*?)\)$/)
      @cta = matches[1..2] if matches
    end

    def remove_last_link(markdown)
      markdown.sub(/\[([^\]]*?)\]\(([^\)]*?)\)$/, "")
    end

  end

  module Overrides
    class << self
      alias_method :render_options_without_headstart, :render_options
    end

    def self.render_options(template, *engines)
      theme_view_path = Nesta::Path.themes('headstartup', 'views')
      local_view_path = Nesta::Path.local("views/landing-pages")
      [local_view_path, theme_view_path].each do |path|
        engines.each do |engine|
          if template_exists?(engine, path, template)
            return { views: path }, engine
          end
        end
      end
      render_options_without_headstart
    end
  end
end

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

  module Routes
    def self.included(app)
      app.instance_eval do
        post '/sign-up' do
          if params[:email] && params[:email] != ""
            begin
              mailchimp = Mailchimp::API.new(ENV["MAILCHIMP_API_KEY"])
              mailchimp.lists.subscribe(ENV["MAILCHIMP_LIST_ID"], email: params[:email])
              haml :signup_thanks, layout: :layout
            rescue Mailchimp::Error => ex
              flash[:error] = ex.message
              redirect back
            end
          else
            redirect back
          end
        end

        #get '/sitemap.xml' do
        #  content_type :xml, charset: 'utf-8'
        #  @pages = Nesta::LandingPage.find_all.reject do |page|
        #    page.draft? or page.flagged_as?('skip-sitemap')
        #  end
        #  @last = @pages.map { |page| page.last_modified }.inject do |latest, page|
        #    (page > latest) ? page : latest
        #  end
        #  haml(:sitemap, format: :xhtml, layout: false)
        #end

        #app.get '/css/:sheet.css' do
        #  content_type 'text/css', charset: 'utf-8'
        #  stylesheet(params[:sheet].to_sym)
        #end

        #app.get '*' do
        #  set_common_variables
        #  parts = params[:splat].map { |p| p.sub(/\/$/, '') }
        #  @page = Nesta::LandingPage.find_by_path(File.join(parts))
        #  @page ||= Nesta::Page.find_by_path(File.join(parts))
        #  raise Sinatra::NotFound if @page.nil?
        #  @title = @page.title
        #  set_from_page(:description, :keywords)
        #  haml(@page.template, layout: @page.layout)
        #end
      end
    end
  end
end

#module Headstartup
#  class App < Nesta::App
#    app_file = Nesta::Path.themes('headstartup', 'app.rb')
#    require app_file if File.exist?(app_file)
#    include Headstartup::Routes
#    helpers Headstartup::Helpers
#  end
#end

class Headstart < Nesta::App
  register Sinatra::Flash
  helpers Nesta::Overrides::Renderers
  helpers Nesta::Navigation::Renderers
  helpers Nesta::View::Helpers
  helpers Headstartup::Helpers
  include Headstartup::Routes
  def stylesheet(template, options = {}, locals = {})
    defaults, engine = Nesta::Overrides.render_options(template, :sass, :scss)
    defaults.merge!(style: :compressed)
    renderer = Sinatra::Templates.instance_method(engine)
    renderer.bind(self).call(template, defaults.merge(options), locals)
  end

  def scss(template, options = {}, locals = {})
     defaults, engine = Nesta::Overrides.render_options(template, :scss)
    defaults.merge!(style: :compressed)
     super(template, defaults.merge(options), locals)
   end

   def sass(template, options = {}, locals = {})
     defaults, engine = Nesta::Overrides.render_options(template, :sass)
     defaults.merge!(style: :compressed)
     super(template, defaults.merge(options), locals)
   end
end
#module Nesta
#  class App
#    helpers Headstartup::Helpers
#  end
#end

require 'nesta/models'
module Nesta
  class Page
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
end

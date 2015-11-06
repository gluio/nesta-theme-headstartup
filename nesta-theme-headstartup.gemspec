# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nesta-theme-headstartup/version'

Gem::Specification.new do |spec|
  spec.name          = "nesta-theme-headstartup"
  spec.version       = Nesta::Theme::Headstartup::VERSION
  spec.authors       = ["Glenn Gillen"]
  spec.email         = ["me@glenngillen.com"]
  spec.summary       = %q{A startup landing page focussed theme for NestaCMS.}
  spec.homepage      = "https://contentfocus.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "nesta"
  spec.add_runtime_dependency "nesta-contentfocus-extensions"
  spec.add_runtime_dependency "bourbon"
  spec.add_runtime_dependency "neat"
  spec.add_runtime_dependency "mailchimp"
  spec.add_runtime_dependency "sequel_pg"
end

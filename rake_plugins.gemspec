require File.expand_path("../lib/rake_plugins/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "rake_plugins"
  s.version     = RakePlugins::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nick Ragaz"]
  s.email       = ["nick.ragaz@gmail.com"]
  s.homepage    = "http://github.com/nragaz/rake_plugins"
  s.summary     = "Simple Rails plugin management using Rake"
  s.description = "Creates installed.yml in vendor/plugins to track your plugin sources and enable mass updating"

  s.required_rubygems_version = ">= 1.3.6"

  s.rubyforge_project         = "rake_plugins"

  s.files        = Dir["{lib}/**/*.rb", "*.md"]
  s.require_path = 'lib'
end
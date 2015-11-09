$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "blacklight_suggest/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "blacklight_suggest"
  s.version     = BlacklightSuggest::VERSION
  s.authors     = ["Matt Zumwalt"]
  s.email       = ["matt@databindery.com"]
  s.summary       = %q{autocomplete functionality for blacklight.}
  s.description   = %q{Rails engine that enables javascript-based autocomplete in the search query box and adds core support for spelling & completion suggesters.}
  s.homepage      = "https://github.com/projectblacklight/blacklight/wiki/Blacklight-Add-ons"
  s.license       = "APACHE2"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "blacklight", "~> 5.15"
  s.add_dependency "twitter-typeahead-rails"

  s.add_development_dependency "rails", "~> 4.2.4"
  s.add_development_dependency "rspec-rails", "~> 3.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "engine_cart"
  s.add_development_dependency "jettywrapper", "> 2.0.0"
  s.add_development_dependency "solr_wrapper"

end

# coding: utf-8

Gem::Specification.new do |s|
  s.name = 'contentr'
  s.version = '0.1.0'
  s.summary = %q{CMS engine for Rails}
  s.description = %q{Contentr is a Content Management System (CMS) that plugs into any Rails 3.1 application as an engine.}
  s.authors = ["Rene Sprotte", "Dr. Peter Horn"]
  s.email = ['team@metaminded.com']
  s.homepage = 'http://github.com/metaminded/contentr'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.add_dependency 'rake',           '~> 10.3.0'
  s.add_dependency 'rails',          '>= 4.0.0'
  s.add_dependency 'simple_form',    '~> 3.1.0.rc1'
  s.add_dependency 'bson_ext',       '~> 1.5'
  s.add_dependency 'compass-rails',  "~> 1.1.3"
  s.add_dependency 'sass-rails'
  s.add_dependency 'bootstrap-sass', '~> 3.1.0'
  s.add_dependency 'bootstrap-wysihtml5-rails', "~> 0.3.1.23"
  s.add_dependency 'font-awesome-rails'
  s.add_dependency 'carrierwave', '~> 0.10.0'
  s.add_dependency 'jquery-ui-rails', '~> 4.2.0'
  s.add_dependency 'ancestry', '~> 2.1.0'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'factory_girl_rails', "~> 4.4.0"
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'rspec-rails', '~> 3.0.0.beta'
end

# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'capybara/rspec'
require 'factory_girl'
require 'database_cleaner'
require 'capybara/poltergeist'

include ActionDispatch::TestProcess

Capybara.javascript_driver = :poltergeist

FactoryGirl.find_definitions

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }



RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    Capybara.reset_sessions!
    DatabaseCleaner.clean
  end


end

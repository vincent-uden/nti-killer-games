ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.require

require_relative '../../app'
require 'capybara/rspec'

Capybara.app = App
Capybara.server = :webrick
#Capybara.app_host = 'http://localhost:'

Capybara.default_driver = :selenium_chrome
if ENV['headless'] == 'true'
  Capybara.default_driver = :selenium_chrome_headless
end

# TODO Populate user data


require 'bundler'
Bundler.require

require 'capybara/rspec'

ENV['RACK_ENV'] = 'test'

require_relative './helper_class'
Helper.populate_user_data

require_relative '../../app'
require_relative '../../utils'
require_relative '../../database/database'
require_relative '../../database/models/tables'
require_relative '../../database/models/code_words'
require_relative '../../database/models/users'
require_relative '../../database/models/gamestate'
require_relative '../../scripts/generate-target-sequence'

generate_sequence

Capybara.app = App
Capybara.server = :webrick
#Capybara.app_host = 'http://localhost:'

Capybara.default_driver = :selenium_chrome
if ENV['headless'] == 'true'
  Capybara.default_driver = :selenium_chrome_headless
end


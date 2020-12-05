if ENV['RAILS_ENV'] ||= 'test'
  require_relative '../config/environment'
  require 'rails/test_help'
  require 'simplecov'

  SimpleCov.start 'rails'
  puts 'required simpleCov'
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors, with: :threads)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

module AuthenticationHelpers
  
  def login
    if respond_to? :visit
      visit login_url
      fill_in :name, with: users(:one).name
      fill_in :password, with: 'secret'
      click_on 'Login'
    else
      post login_url, params: { name: users(:one).name, password: 'secret' } 
    end
  end

  def logout
    # delete logout_url
  end

  def setup
  end
end

class ActionDispatch::IntegrationTest
  include AuthenticationHelpers
end

class ActionDispatch::SystemTestCase
  include AuthenticationHelpers
end

require "rubygems"
require "rspec"
require File.dirname(__FILE__) + "/../lib/template-test"

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Template::Test
end
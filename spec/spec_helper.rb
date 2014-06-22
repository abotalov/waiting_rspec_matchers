require 'pry'
require 'waiting_rspec_matchers'

RSpec.configure do |config|
  config.include WaitingRspecMatchers
end

require 'pry'
require 'waiting_rspec_matchers'

class CustomMatcher
  def initialize(expected)
    @expected = expected
  end

  def matches?(actual)
    actual == @expected
  end

  def failure_message
    'something went wrong'
  end
end

module CustomMatchers
  def custom_eq(expected)
    CustomMatcher.new(expected)
  end
end

RSpec.configure do |config|
  config.include WaitingRspecMatchers
  config.include CustomMatchers
end

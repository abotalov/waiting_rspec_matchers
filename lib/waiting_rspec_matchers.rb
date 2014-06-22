require 'waiting_rspec_matchers/version'

require 'rspec/expectations'

module WaitingRspecMatchers

  class << self
    attr_accessor :default_wait_time, :default_delay

    def configure
      yield self
    end
  end

  WaitingRspecMatchers.configure do |config|
    config.default_wait_time = 2
    config.default_delay = 0.05
  end

  private

  BECOME_REGEX = /^become_(.+)/

  def method_missing(method, *args, &expected_block)
    if m = method.to_s.match(BECOME_REGEX)
      matcher_class_name = "Become#{m[1].capitalize}Matcher"
      if WaitingRspecMatchers.const_defined?(matcher_class_name)
        k = WaitingRspecMatchers.const_get(matcher_class_name)
      else
        k = define_matcher_class(matcher_class_name)
        WaitingRspecMatchers.const_set(matcher_class_name, k)
      end

      k.new(m[1], *args, &expected_block)
    else
      super
    end
  end

  def define_matcher_class(matcher_class_name)
    Class.new do
      include ::RSpec::Matchers
      include ::RSpec::Matchers::Composable

      def initialize(rspec_matcher_name, *args, &expected_block)
        @rspec_matcher_name = rspec_matcher_name
        @args = args
        @expected_block = expected_block

        @chains = []
      end

      def during(max_wait_time_in_seconds)
        @max_wait_time = max_wait_time_in_seconds
        self
      end

      def max_wait_time
        @max_wait_time || WaitingRspecMatchers.default_wait_time
      end

      def delay(seconds)
        @delay = seconds
        self
      end

      def match_helper(to_or_not_to, &block)
        start_time = Time.now
        begin
          matcher = __send__(@rspec_matcher_name.to_sym, *@args, &@expected_block)
          @chains.each do |chain|
            matcher = matcher.__send__(chain[0], *chain[1])
          end
          if matcher.supports_block_expectations?
            expect { block.call }.__send__(to_or_not_to, matcher)
          else
            expect(block.call).__send__(to_or_not_to, matcher)
          end
        rescue RSpec::Expectations::ExpectationNotMetError => e
          @failure_message = e.message
          return false if (Time.now - start_time) >= max_wait_time
          sleep @delay || WaitingRspecMatchers.default_delay
          retry
        end
        true
      end

      define_method :matches? do |block|
        match_helper(:to, &block)
      end

      define_method :does_not_match? do |block|
        match_helper(:not_to, &block)
      end

      def failure_message
        @failure_message
      end

      def failure_message_when_negated
        @failure_message
      end

      def supports_block_expectations?
        true
      end

      def method_missing(method, *args)
        @chains << [method, args]
        self
      end
    end
  end
end

# Waiting RSpec Matchers

[![Build Status](https://travis-ci.org/abotalov/waiting_rspec_matchers.svg?branch=master)](https://travis-ci.org/abotalov/waiting_rspec_matchers)

When writing end-to-end tests there is often a necessity to wait for something to happen. Libraries like Capybara provide some functionality to ease it but this functionality doesn't cover all needed cases. Sometimes you need to wait for a more specific condition.

This is where this gem aims to help.

If `some_name` rspec matcher exists, WaitingRspecMatchers provides you `become_some_name` matcher that does the same as `some_name` matcher but also waits for that matcher to succeed.

## Setup

To install, add this line to your Gemfile and run bundle install:
```ruby
gem 'waiting_rspec_matchers'
```

Then you should include it in e.g. `spec_helper.rb`:
```ruby
RSpec.configure do |config|
  config.include WaitingRspecMatchers
end
```

## Usage examples (inspiration)

* reload page until some element/text appears:

```ruby
# setup Capybara
expect do
  visit 'path'
  page
end.to become_have_css('#id')
```

* check that page url is "some_string" or will become "some_string":

```ruby
# setup Capybara
expect { page.current_url }.to become_eq('http://www.google.com/')
```

* wait for element attribute to include a specific string:

```ruby
# setup Capybara
el = find('#id')
expect { el[:class] }.to become_include('some_class')
```

* assert that 3 requests url of which contains `/path` pass through proxy

```ruby
# setup proxy
expect { proxy.har.entries.count { |e| e.request.url[/\/path/]} }.to become_eq(3)
```

## Changing wait time

You can specify a wait time (amount of time that gem will retry supplied block of code) and delay (period between retries).

You can either change default values (it will take effect for all matchers):

```ruby
WaitingRspecMatchers.configure do |config|
  config.default_wait_time = 2
  config.default_delay = 0.05
end
```

or set it on per-matcher basis:

```ruby
expect { some_code }.to become_eq(3).during(2).delay(0.05)
expect { some_code }.to become_eq(3).during(2)
expect { some_code }.to become_eq(3).delay(0.05)
```

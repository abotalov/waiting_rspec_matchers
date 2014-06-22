# Waiting RSpec Matchers

[![Build Status](https://travis-ci.org/abotalov/waiting_rspec_matchers.svg?branch=master)](https://travis-ci.org/abotalov/waiting_rspec_matchers)

If `some_name` rspec matcher exists, WaitingRspecMatchers provides you `become_same_name` matcher that does the same as `some_name` matcher but also waits for that matcher to succeed.

Usage examples (inspiration):

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

## Installation

Add this line to your application's Gemfile:

    gem 'waiting_rspec_matchers'

And then execute:

    $ bundle

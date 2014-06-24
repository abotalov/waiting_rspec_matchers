# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'waiting_rspec_matchers/version'

Gem::Specification.new do |s|
  s.name          = 'waiting_rspec_matchers'
  s.version       = WaitingRspecMatchers::VERSION
  s.authors       = ['Andrey Botalov']
  s.summary       = %q{New become_* RSpec matchers that do the same as * matchers but also wait}
  s.homepage      = 'https://github.com/abotalov/waiting_rspec_matchers'
  s.license       = 'MIT'

  s.files         = `git ls-files -- lib/*`.split("\n")
  s.require_path  = 'lib'

  s.required_ruby_version = '>= 1.9.3'

  s.add_runtime_dependency 'rspec-expectations', ['~> 3.0']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
end

$: << File.expand_path("../../lib", File.dirname(__FILE__))
require 'rspec/bisect'
require 'aruba/cucumber'

Before do
  @aruba_timeout_seconds = 5
end
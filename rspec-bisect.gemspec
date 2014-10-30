# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/bisect/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-bisect"
  spec.version       = Rspec::Bisect::VERSION
  spec.authors       = ["Shelby Doolittle"]
  spec.email         = ["shelby@shelbyd.com"]
  spec.summary       = %q{Detect order dependencies in rspec test suites.}
  spec.description   = %q{Detect order dependencies in rspec test suites. Also print the minimal set of tests to reproduce the failure(s).}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
end

# DEPRECATED

RSpec has a command that will perform the same features as this project. Prefer to use that instead.

    $ rspec --seed 1234 --bisect
    
See [their documentation](https://relishapp.com/rspec/rspec-core/docs/command-line/bisect) for more details.

# Rspec::Bisect

Detect order dependencies in rspec test suites and print a minimal list of tests required to reproduce it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-bisect'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-bisect

## Usage

So you think you have order dependencies? This tool will tell you exactly which tests are causing that dependency. It won't try to figure out if one exists or tell you why it's happening.

Have your rspec config set so that ```rspec --seed 1234``` runs your test suite with the specified seed.

Run ```rspec-bisect --seed 1234``` and rspec-bisect will tell you which tests are from an order dependency and the minimum tests required to reproduce it.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rspec-bisect/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

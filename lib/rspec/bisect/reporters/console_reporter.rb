require 'colorize'

module RSpec
  module Bisect
    module Reporters
      class ConsoleReporter
        include Reporter

        def report(text)
          puts text
        end

        def report_success(text)
          report text.green
        end

        def report_failure(text)
          report text.red
        end
      end
    end
  end
end
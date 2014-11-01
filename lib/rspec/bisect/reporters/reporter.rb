module RSpec
  module Bisect
    module Reporters
      module Reporter
        def seed(seed)
          if seed.nil?
            report 'Running tests with no seed'
          else
            report "Running tests with seed #{seed}"
          end
        end

        def failing_tests(failure_count)
          if failure_count > 0
            report_failure "#{failure_count} failing test#{failure_count > 1 ? 's' : ''}.".red
          else
            report_success 'No failing tests.'
          end
        end

        def order_dependent_examples(examples)
          if examples.size > 0
            report "Order dependenc#{ examples.size > 1 ? 'ies' : 'y'} detected:"
            examples.each do |example|
              report_failure "\t#{example['full_description']}"
            end
          else
            report_success 'No order dependencies.'
          end
        end

        def determining_culprits(example)
          report ''
          report "Culprits for #{example['full_description']}:"
        end

        def culprits(culprits, example)
          culprits.each { |culprit| puts culprit['full_description'].green }

          report_failure example['full_description']
        end
      end
    end
  end
end
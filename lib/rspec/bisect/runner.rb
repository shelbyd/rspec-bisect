require 'json'
require 'colorize'
require 'optparse'
require 'ruby-progressbar'

module RSpec
  module Bisect
    class Runner
      def execute!
        @options = {}
        def options
          @options
        end

        OptionParser.new do |opts|
          opts.banner = 'Usage: rspec-bisect [options]'

          opts.on('-s', '--seed N', Integer, 'Seed that causes order dependencies') do |s|
            options[:seed] = s
          end

          opts.on('--help', 'Show this message') do
            puts opts
            exit
          end
        end.parse!

        if options[:seed].nil?
          puts 'Running tests with no seed'
        else
          puts "Running tests with seed #{options[:seed]}"
        end

        def rspec_seed_argument
          options[:seed].nil? ? '' : "--seed #{options[:seed]}"
        end

        result = `rspec --format json #{rspec_seed_argument}`
        parsed = JSON.parse result

        examples = parsed['examples']
        failure_count = parsed['summary']['failure_count']
        if failure_count > 0
          puts "#{failure_count} failing test#{failure_count > 1 ? 's' : ''}.".red
        else
          puts 'No failing tests.'.green
        end

        failing_examples = examples.select { |e| e['status'] == 'failed' }

        def examples_as_rspec_params(examples)
          examples.map { |e| "#{e['file_path']}:#{e['line_number']}" }.join ' '
        end

        def run_examples_command(examples)
          "rspec #{examples_as_rspec_params(examples)} #{rspec_seed_argument}"
        end

        def run_examples(examples)
          `#{run_examples_command(examples)}`
        end

        def last_command_passed?
          $?.exitstatus == 0
        end

        def last_command_failed?
          not last_command_passed?
        end

        def progress_bar(additional_options)
          ProgressBar.create({format: '%t |%w>%i| %c/%C |%e'}.merge(additional_options))
        end

        dependent_examples_progress = progress_bar title: 'Detecting Dependent Examples',
                                                   total: failing_examples.size

        order_dependent_examples = failing_examples.select do |example|
          run_examples([example])
          passed = last_command_passed?
          dependent_examples_progress.increment
          passed
        end

        if order_dependent_examples.size > 0
          puts "Order dependenc#{ order_dependent_examples.size > 1 ? 'ies' : 'y'} detected:"
          order_dependent_examples.each do |example|
            puts "\t#{example['full_description']}".red
          end
        else
          puts 'No order dependencies.'.green
        end

        order_dependent_examples.each do |example|
          puts
          puts "Culprits for #{example['full_description']}:"

          culprit_progress = progress_bar title: 'Determining culprits',
                                          total: nil,
                                          format: '%t |%i| %c potential culprits'

          culprits = examples.take_while do |e|
            example['file_path'] != e['file_path'] ||
                example['line_number'] != e['line_number']
          end

          culprit_progress.progress = culprits.size

          culprit_count_theory = 1
          while culprits.size > culprit_count_theory
            found_useless_group = false
            culprits.each_slice(culprits.size / (culprit_count_theory + 1)) do |excluded_culprits|
              culprit_progress.progress = culprits.size

              culprit_group = culprits - excluded_culprits
              run_examples culprit_group + [example]

              culprit_progress.progress = culprits.size
              if last_command_failed?
                culprits = culprit_group

                found_useless_group = true
                break
              end
            end

            culprit_count_theory += 1 unless found_useless_group
          end

          culprit_progress.stop

          culprits.each { |candidate| puts candidate['full_description'].green }

          puts example['full_description'].red

          puts (run_examples_command culprits + [example]).red
        end
      end
    end
  end
end
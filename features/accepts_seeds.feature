Feature: accepts seeds for first rspec run

  Scenario: suite requires seeds
    Given a file named "spec/failing_spec.rb" with:
    """ruby
      RSpec.describe 'a test that' do
        cause_failure = false
        it 'fails' do
          expect(cause_failure).to be false
        end

        it 'passes' do
          cause_failure = true
        end
      end
      """
    When I run `rspec-bisect --seed 2`
    Then the output should contain:
    """
    a test that passes
    a test that fails
    """

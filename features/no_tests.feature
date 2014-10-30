Feature: no failures with no tests

  Scenario: no test files
    When I run `rspec-bisect`
    Then the output should contain "No failing tests."
    And the output should contain "No order dependencies."

  Scenario: no tests defined
    Given a file named "spec/empty_spec.rb" with:
      """ruby
      RSpec.describe 'no tests' do
      end
      """
    When I run `rspec-bisect`
    Then the output should contain "No failing tests."
    And the output should contain "No order dependencies."

  Scenario: no failing tests
    Given a file named "spec/empty_spec.rb" with:
      """ruby
      RSpec.describe 'no tests' do
        it 'passes' do
        end
      end
      """
    When I run `rspec-bisect`
    Then the output should contain "No failing tests."
    And the output should contain "No order dependencies."
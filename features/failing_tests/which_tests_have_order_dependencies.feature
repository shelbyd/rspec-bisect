Feature: which tests have order dependencies

  Scenario: one test causes another test to fail
    Given a file named "spec/failing_spec.rb" with:
      """ruby
      RSpec.describe 'a test that' do
        cause_failure = false
        it 'passes' do
          cause_failure = true
        end

        it 'fails' do
          expect(cause_failure).to be false
        end
      end
      """
    When I run `rspec-bisect`
    Then the output should contain "1 failing test."
    And the output should not contain "No order dependencies."
    And the output should contain "Order dependency detected:"
    And the output should contain "a test that fails"

  Scenario: one test causes another test to fail
    Given a file named "spec/failing_spec.rb" with:
      """ruby
      RSpec.describe 'a test that' do
        cause_failure = false
        it 'passes' do
          cause_failure = true
        end

        it 'fails' do
          expect(cause_failure).to be false
        end

        it 'also fails' do
          expect(cause_failure).to be false
        end
      end
      """
    When I run `rspec-bisect`
    Then the output should contain "2 failing tests."
    And the output should not contain "No order dependencies."
    And the output should contain "Order dependencies detected:"
    And the output should contain "a test that fails"
    And the output should contain "a test that also fails"

Feature: prints order dependencies

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
    Then the output should contain:
    """
    a test that passes
    a test that fails
    """

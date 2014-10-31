Feature: prints order dependencies for multiple test dependencies

  Scenario: two tests causes another test to fail
    Given a file named "spec/failing_spec.rb" with:
      """ruby
      RSpec.describe 'a test that' do
        cause_failure = 0
        it 'passes' do
          cause_failure += 1
        end

        it 'also passes' do
          cause_failure += 1
        end

        it 'fails' do
          expect(cause_failure).to be < 2
        end
      end
      """
    When I run `rspec-bisect`
    Then the output should contain:
    """
    a test that passes
    a test that also passes
    a test that fails
    """

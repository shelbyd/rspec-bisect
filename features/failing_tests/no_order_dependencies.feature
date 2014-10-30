Feature: no order dependencies

  Scenario: One failing test
    Given a file named "spec/failing_spec.rb" with:
      """ruby
      RSpec.describe 'failing test' do
        it 'fails' do
          expect(1).to eq 2
        end
      end
      """
    When I run `rspec-bisect`
    Then the output should contain "1 failing test."
    And the output should not contain "No failing tests."
    And the output should contain "No order dependencies."

  Scenario: Two failing tests
    Given a file named "spec/failing_spec.rb" with:
      """ruby
      RSpec.describe 'failing test' do
        it 'fails' do
          expect(1).to eq 2
        end
        it 'fails also' do
          expect(2).to eq 3
        end
      end
      """
    When I run `rspec-bisect`
    Then the output should contain "2 failing tests."
    And the output should not contain "No failing tests."
    And the output should contain "No order dependencies."
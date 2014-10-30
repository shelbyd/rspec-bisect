Feature: no failures with no tests

  Scenario: no test files
    When I run `rspec-bisect`
    Then the output should contain "No failing tests."
    And the output should contain "No order dependencies."
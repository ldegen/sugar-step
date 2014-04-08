#language: en

Feature: Uncluttered asynchronous step definitions

  As a developer
  I want SugarStep to transparently handle asynchronous steps for me
  So that I don't have to clutter my step definitions with irrelevant boiler plate code.

  More specifically, I expect to see zero boiler plate in my step definition if
   - the step code is synchronous
   - the step code produces a promise-like object

  Please refer to ../sugar-step.litcoffee for more details.

  Scenario: Successful synchronous step
    Given a successful synchronous step
    When the step is executed
    Then I expect it to pass

  Scenario: Successful asynchronous step
    Given a successful asynchronous step
    When the step is executed
    Then I expect it to pass

  Scenario: Failing synchronous step
    Given a failing synchronous step
    When the step is executed
    Then I expect it to fail

  @wip
  Scenario: Explicit callback handling by the step
    Given a step with a callback-argument
    When the step is executed
    Then the sugar step shall not interfere

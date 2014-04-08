module.exports = ->
  assert = require "assert"

 
  @Given /^a (successful|failing) (synchronous|asynchronous) step$/, (result,type,callback)->
    @sugarStep= @step "executing a #{result} #{type} step"
    callback()
  
  @Given /^a step with a callback\-argument$/, (callback) ->
    @sugarStep= @step "executing a step with a callback argument"
    callback()

  @When /^the step is executed$/, (callback) ->
    @sugarStep.execute()
    callback()

  @Then /^I expect it to (pass|fail)$/, (outcome,callback) ->
    @sugarStep.expectOutcome(outcome,callback)


  @Then /^the sugar step shall not interfere$/, (callback) ->
    @sugarStep.expectNoInterference(callback)

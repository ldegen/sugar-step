Promise = require "promise"
module.exports = ->
  @World = require("../support/world.coffee").World
  SugarStep = require "../../sugar-step.litcoffee"

  # Normally, there would be no need to put this in a before hook.
  @Before (callback)->

    When = SugarStep @mockDefineStep

    When /^executing a successful synchronous step$/, ->
      #nop

    When /^executing a failing synchronous step$/, ->
      throw new Error("Failed, as expected")

    When /^executing a successful asynchronous step$/, ->
      new Promise (resolve,reject)->
        setTimeout (-> resolve "success" ), 100

    When /^executing a failing asynchronous step$/, ->
      new Promise (resolve,reject)->
        setTimeout (-> resolve "success" ), 100

    When /^executing a step with a callback argument$/, (callback)->
      setTimeout (-> callback("explicit") ), 100

    callback()


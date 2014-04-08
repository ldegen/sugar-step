Promise = require 'promise'
SugarStep = require "../../sugar-step.litcoffee"

module.exports = () ->
  pattern = /^something with an (argument)$/
  shouldFail = false
  shouldBeAsynchronous = false
  shouldHandleCallback = false


  build: () ->
    impl = (arg,callback) ->
      if shouldBeAsynchronous
        new Promise (resolve,reject)->
          setTimeout (-> if shouldFail then reject "failed, as expected" else resolve "success" ), 100
      else if shouldHandleCallback
        if shouldFail then callback.fail() else callback()
      else
        if shouldFail then throw new Error("failed, as expected")
    body = if shouldHandleCallback then impl else (arg -> impl(arg))

    outside = {}
    mockDefineStep = (pattern,body)->
      outside.pattern = pattern
      outside.body = body

    defineSugarStep = SugarStep mockDefineStep
    defineSugarStep pattern, body

    execute: (callback) ->
      #execute the sugar step
    expectOutcome: (outcome, callback) ->
      #check if the step passed or failed as expected

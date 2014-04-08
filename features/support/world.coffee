Promise = require "promise"
Deferred = () ->
  resolve = undefined
  reject = undefined
  promise = new Promise (res,rej) ->
    resolve=res
    reject=rej
  resolve:resolve
  reject:reject
  promise:promise

MockStep = (pattern,body) ->
  deferred = Deferred()
  cb = (result)->
    deferred.resolve(result)
  cb.fail = (error)->
    deferred.reject(error)

  pattern:pattern
  expectOutcome: (outcome,callback)->
    onSuccess = () ->
      if outcome == "pass" then callback() else callback.fail("expected #{outcome}")
    onFailure = () ->
      if outcome == "fail" then callback() else callback.fail("expected #{outcome}")
    deferred.promise.done onSuccess,onFailure
  expectNoInterference: (callback) ->
    onSuccess = (argument) ->
      if argument == "explicit" then callback() else callback.fail("expected 'explicit' as an argument to the callback")
    onFailure = () ->
      if outcome == "fail" then callback() else callback.fail("expected succeding step")
    deferred.promise.done onSuccess,onFailure
    
  execute: ->
    try
      body.call this, cb
    catch err
      deferred.reject(err)

World = (callback) ->
  definedSteps = []
  @step=(string)->
    definedSteps.filter( (step)-> step.pattern.test string)[0]

  @mockDefineStep=(pattern,body)->
    definedSteps.push MockStep(pattern,body)

  callback()


module.exports.World = World

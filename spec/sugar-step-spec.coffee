describe "A Sugar Step", ->
  SugarStep = require "../sugar-step"
  step = undefined
  originalDefineStep = undefined
  callback = undefined
  result=undefined
  that = {}

  wrappedPattern = ()->
    originalDefineStep.mostRecentCall.args[0]

  wrappedBody = () ->
    originalDefineStep.mostRecentCall.args[1]


  beforeEach ->
    callback=createSpy()
    callback.fail=createSpy()
    result=createSpy()
    originalDefineStep=createSpy()
    step = SugarStep originalDefineStep

  it "passes the pattern unchanged", ->
    pattern = /pattern/
    step pattern, (->)
    expect(wrappedPattern()).toBe pattern

  it "lets the test fail if the original body raises an exception", ->
    error = new Error("Not so unexpected exception")
    step /^bla(.+)$/, (arg) -> throw error
    wrappedBody().call(that,"baz",callback)
    expect(callback.callCount).toBe 0
    expect(callback.fail).toHaveBeenCalledWith error

  it "simply relays to the given body if it declares an explicit callback argument", ->
    step /^bla(.+)$/, (arg, cb) -> result(this,arg,cb)
    wrappedBody().call(that,"baz",callback)
    expect(callback.callCount).toBe 0
    expect(result).toHaveBeenCalledWith that,"baz",callback

  it "wires up the callback if the body returns something that looks like a promise", ->
    step /^bla(.+)$/, (arg) ->
      result(this,arg)
      'then': (successCb,failureCb)->
        successCb()
        failureCb("fail")

    wrappedBody().call(that,"baz",callback)
    expect(callback.callCount).toBe 1
    expect(callback).toHaveBeenCalledWith()
    expect(callback.fail).toHaveBeenCalledWith("fail")

  it "assumes a successfuly synchronous step if the body does not declare a callback argument and succeeds without returning a promise", ->
    step /^bla(.+)$/, (arg) ->
      result(this,arg)
      "I am *not* a promise"
    wrappedBody().call(that,"baz",callback)
    expect(callback.callCount).toBe 1


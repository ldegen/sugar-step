Motivation
==========
In any real-world javascript application you will typically encounter
a mix of synchronous and asynchronous steps. Cucumber-JS anticipates this
by passing a callback argument into each step that you need to signal when the body
of your step definition is done. This is a very basic, unbiased approach that 
works well, because it does not impose any assumption on how *your* application
deals with asynchronous code. 

On the other hand it forces you to add code to your step definitions that 
exposes technical detail without telling a reader anything about your domain.
Even if your steps are synchronous, you need to call the callback because there
is no way for Cucumber to know. 

I like my step definitions short. In fact, I prefer them to be one-liners. 
Not possible with the callback-based approach. So... how can we fix this?

I want a solution that covers the following cases:

1. Asynchronous steps where the step body explicitly deals with the callback "the Cucumber way".

2. Asynchronous steps where the step body returns a promise (a.k.a. "future" or "deferred" Object).
   This fits in neatly if the domain under test already deals with its asynchronous stuff this way.
   It turned out to be the variant I use most often.

3. Synchronous steps. They should not be cluttered with boring boilerplate.

So we need a little magic that wrapps around the body of a step definition and determins
which of the three variants it is dealing with. For variants 2 and 3 the wrapper should
take care of the whole callback business to leave the step definition crisp and clean.


Implementation
==============

The SugarStep is implemented in a common-js module exporting a single function that basically 
creates a decorator for the original "defineStep"-directive defined by Cucumber-JS.
The decorator passes the RegExp unchanged to the decorated defineStep function, but it wraps the
step body function in our callback handling magic.

    module.exports = defineMagicStep = (defineStep) ->
      (pattern, body) ->
        defineStep pattern, wrap(body)


The wrapper function is where the actual magic happens. It takes the step definition
body as only argument and produces a modified body that takes care of the 
callback handling.

    wrap = (body) ->
      ->
        args = Array::slice.call(arguments)
        callback = args[args.length - 1]
        retval = undefined

First, we simply execute the original body. If it raises an exception, we let the test fail.
 
        try
          retval = body.apply(this, args)
        catch e 
          console.log(e)         
          callback.fail e
          return
        
Next, we check whether the body expects a callback as an extra argument.
This can be determined by comparing the number of formal arguments of the body
with the number of arguments the wrapper was called with. Cucumber will always provide the
callback, so if both numbers are equal, we can safely assume that the body explicitly handles
the callback itself. There is nothing left to do in that case.

        return retval  if args.length is body.length

Otherwise, we test whether the body has returned a promise (a.k.a. deferred object or future).
Here we assume a convention followed by jQuery and many other toolkits by which a promise object
must provide a function with the signature then(successCallback,failureCallback).
If the returned object has such a property, we use it to wire up the callback given to us
by cucumber.

        if retval and retval.then
          retval.then (-> callback()), ((e) -> callback.fail e)
          return

Finally, if none of the above holds, we assume that the step has finished synchronously and 
successfully.
        
        callback()

And that's really it. :-)


UPDATE: This is probably obsolete by now!
=========================================
I just learned that since v5.0 Cucumber.js supports promises out-of-the-box.
I haven't tried it yet, but from the docs it seems that it works just as one would expect.
So instead of using sugar-step you should probably just upgrade your cucumber.js. :)


sugar-step
==========

Syntactic sugar for handling asynchronous step definitions in cucumber-js

The idea is that instead of this

``` coffeescript
  Given /^I have a trivial, synchronous step$/, (callback) ->
    trivial.but.intersting.stuff()
    callback()

  And /^there is also non-trivial, asynchronous stuff$/, (callback) ->
    do.stuff.that.produces.a.promise().then(
      () ->
        callback(), 
      (err) ->
        callback.fail(err))(
    )
    
```    
you would generally prefer to write this instead:

``` coffeescript
  Given /$I have a trivial, synchronous step^/, ->
    trivial.but.intersting.stuff()

  And /$there is also a non-trivial, asynchronous stuff^/, ->
    do.stuff.that.produces.a.promise()
```

But out-of-the-box, cucumber-js won't let you do that, so I started looking for a solution. If you are like me and

  - you use promises a lot
  - you like your step definitions *short*

then this one may be just for you.

For a more detailed explanation of the How and the Why, please refer to [the implementation](./src/sugar-step.litcoffee).

Installation
------------

```
npm install sugar-step
```

Usage
-----
Something like this:

``` coffeescript
SugarStep = require 'sugar-step'

module.exports = ->

  # wrap the original step definition directive
  Given = When = Then = SugarStep @defineStep

  # ... and you're good to go

  Given /^I have (\d+) cukes in my belly$/, (numberOfCukes) ->
    @belly.cukes=numberOfCukes
    
  # etc.
```

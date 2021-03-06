# Middleware

The `Middleware` class is a factory for creating a Middleware suite that contains a Runner and individual Mw components.

The following Mw-components work with this middleware

* [model-mw](https://github.com/kristianmandrup/model-mw)
* [authorization-mw](https://github.com/kristianmandrup/authorization-mw)
* [validation-mw](https://github.com/kristianmandrup/validation-mw)
* [decorator-mw](https://github.com/kristianmandrup/decorator-mw)
* [marshaller-mw](https://github.com/kristianmandrup/marshaller-mw)


Here we create a `Middleware` with a `ModelRunner` and register the `Mw` components
 `authorizer` and `validator` to be run by the ModelRunner.

```LiveScript
model-middleware = new Middleware('model', data: person).use(authorizer).use(validator)
model-middleware.run!
```

The argument `data: person` sets the context (data) to be sent through the middleware pipeline.
Alternatively you can set the context directly when executing `run` on the middleware.

`model-middleware.run data: person`

Registering runners

The `ModelRunner` from the [model-mw](https://github.com/kristianmandrup/model-mw) project is pre-registered by this project as it is the base runner for all the most commonly used Mw-components.
In effect the following statement is run:

`Middleware.register model: ModelRunner`

You are free to register your own runners for use with Middleware.

```LiveScript
Middleware.register baby-runner: RunBaby
my-middleware = new Middleware('baby-runner').use(my-little-cute-baby-mw)
my-middleware.run my-baby
```

See the [wiki](https://github.com/kristianmandrup/middleware/wiki) for more details on the internal mechanics.

## Error

You can raise an error simply by issuing `error(msg)` from within a mw-component. This will add the error
to the `errors` object of the runner.

This will not abort further execution, but will mean that when the runner finishes execution the errors object is returned instead of the result of execution. This will also set the runner `success` to false.

```LiveScript
mw.base.run = ->
  @error 'Some stupid shit happened!'
```

### Localized errors

You can also add localized errors like this:

```LiveScript
mw.base.run = ->
  @localized-error @localize('Some stupid shit happened!')
```

Note that both "normal" errors and localized errors are stoped side-by-side in seperate containers.
Thus you could have an errors list of keys, and then look up those keys to produce the localized errors to display to the user (typically on the client). The error keys can be used as "master records" in the code to identify specific types of errors. 

This could be extended to load errors from i18n.json files in some localization library such as [i18n.js](https://github.com/fnando/i18n-js) or [i18next](http://i18next.com/) or similar.

## Aborting

You can abort further mw-component execution by the runner, simply by issuing `abort!` in the mw-component.
This will also set the runner `success` to false.

```LiveScript
mw.base.run = ->
  @abort!
```

## Other handies

Any Mw-component also have the following methods available which are all forwarded to the runner.

 * aborted
 * has-errors
 * is-success
 * is-failure

The `runner` is always available from any Mw-component, and here a few more methods are available from [BaseRunner](https://github.com/kristianmandrup/middleware/blob/master/runner/base_runner.ls) such as the `last-mw` and `current-mw` methods. Importantly, the runner maintains a `results` object, with a key for each Mw-component that has been run and the result of the run method.
There is also a `last-result` method and `result-of(mw-component or name)` available on the runner and each Mw-component for any Mw-component
to check up on a previous result.

## Running promises

If the `run` method contains a promise, it will often be unable to return the result of said promise
Instead the callback or done handler of the promise can set the `@result` of the Mw-component and
this result will be used by the runner to set the result instead of the return value.
Note: It only works if the `run` method returns `void`.

## Async Runner

The current `BaseRunner` is very simple and only supports running the Mw-component a synchronous flow mode.
This is not always optimal!

There should be an `AsyncRunner` available that supports running Mw-components asynchronously.
This runner should employ promises and have each Mw-component return a promise as the result.
It should then only complete when all Mw-components have delivered their results.

The async runner(s) should support both *Q* and *RSVP*, by allowing configuration
 of `defer` function (same as *LGTM* validator approach).

Both these promise libraries support a "wait for all promised fulfilled" strategy.

Please help out with this effort ;)

Initial "skeleton" has been started...

## Testing

Using *mocha*

Run all test

`$ mocha`

Run particular test

`$ mocha test/middleware/runner/base_runner_test.js`


## Contribution

Please suggest improvements and help improve this project :)

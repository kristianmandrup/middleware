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

## Aborting

You can abort further mw-component execution by the runner, simply by issuing `abort!` in the mw-component.
This will also set the runner `success` to false.

```LiveScript
mw.base.run = ->
  @abort!
```

## Running promises

If the `run` method contains a promise, it will often be unable to return the result of said promise
Instead the callback or done handler of the promise can set the `@result` of the Mw-component and
this result will be used by the runner to set the result instead of the return value.
Note: It only works if the `run` method returns `void`.

## TODO

The current `BaseRunner` is very simple and only supports running every Mw-component in synchronous mode.
This is not always optimal! There should be more advanced runners available that
 support Mw-components that return promises and also one allow running one or more
 Mw-components asynchronously and wait until they all deliver their results etc.

Please help out with this effort ;)

The async runner(s) should support both *Q* and *RSVP*, by allowing configuration
 of `defer` function (same as *LGTM* validator approach).

## Testing

Using *mocha*

Run all test

`$ mocha`

Run particular test

`$ mocha test/middleware/runner/base_runner_test.js`


## Contribution

Please suggest improvements and help improve this project :)

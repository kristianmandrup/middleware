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
model-middleware = new Middleware('model').use(authorizer).use(validator)
```

Registering runners

The `ModelRunner` from the [model-mw](https://github.com/kristianmandrup/model-mw) project is pre-registered by this project as it is the base runner for all the most commonly used Mw-components.
In effect the following statement is run:

`Middleware.register model: ModelRunner`

You are free to register your own runners for use with Middleware.

```LiveScript
Middleware.register baby-runner: RunBaby
my-middleware = new Middleware('baby-runner').use(my-little-cute-baby-mw)
```

## Error

You can cause an error simply by issuing `error(msg)` from within an mw-component. This will add the error
to the `errors` object of the Runner, for the mw-component in question.

This will not abort further execution, but will mean that when the runner finishes execution the errors object is returned
not the result of execution.

```LiveScript
mw.base.run = ->
  @error 'Some stupid shit happened!'
```

## Aborting

You can abort further mw-component executin by the runner, simply by issuing `abort!` in the mw-component.

```LiveScript
mw.base.run = ->
  @abort!
```

## Running promises

If the `run` method contains a promise, it will often be unable to return the result of said promise
Instead the callback or done handler of the promise can set the `@result` of the Mw-component and
this result will be used by the runner to set the result instead of the return value.
Note: It only works if the `run` method returns `void`.

## Testing

Using *mocha*

Run all test

`$ mocha`

Run particular test

`$ mocha test/middleware/runner/base_runner_test.js`


## Contribution

Please suggest improvements and help improve this project :)

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

## BaseMw

The `BaseMw` is a base class for any Mw-component (middleware component).
Each Mw-component is assigned a runner which is responsible for running the components and
maintains the global middleware state (including the result of running each Mw-component)

Each Mw-component has a run method which executes it and returns a result which is stored by the runner in a
results Object (see `BaseRunner`)

```LiveScript
mw.base = new BaseMw name: 'my mw'
mw.base.run!
```

By default a Mw-component is named as per the class, but you can override this default naming by passing
your own name as shown in code above.

## BaseRunner

The `BaseRunner` is a base class that provides the base functionality for any middleware runner.
A typical runner such as `ModelRunner` (see [model-mw](https://github.com/kristianmandrup/model-mw) project) extends `BaseRunner` to be specialized for operating with models.

When constructed, it can be passed a `on-success` function which is returned if all middlewares are run successfully.
It can also take an `on-error` function which is called when one or more middlewares cause an error.

The result of `run` determines if `on-success` or `on-error` is called, depending on whether `runner.errors` is empty or not.

```LiveScript
my-done-fun = ->
  "Success :)"

error-fun = ->
  error: true
  errors: @errors

mw = {}
mw.base     = new BaseMw name: 'my mw'
base-runner = new BaseRunner on-success: my-done-fun, on-error: error-fun
base-runner.use mw.base
base-runner.run!

# can also use with hash of Mw-components, registering each by key
base-runner.use basic: mw.base, super-cool: mw.cool

# or simply by list - default: name from class name, dasherized!
base-runner.use mw.auth, mw.very-cool
```

## Registry

A Registry is used to register (store) a set of Mw-components for a given Runner.

Create registry with empty `middlewares` object

```LiveScript
registry = new Registry
registry.register authorizer
```

The method `register` is used internally by `Runner` when `use` is called with a Mw-component.
For `Middleware` it delegates `use` to `runner.use`.

```LiveScript
# creates a Middleware instance with registry for Mw components
middleware = new Middleware 'model'

# registers the authorizer mw-component
middleware.use authorizer
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

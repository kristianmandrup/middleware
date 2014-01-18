# Middleware

The `Middleware` class is a factory for creating a Middleware suite that contains a Runner and individual Mw components.

Here we create a `Middleware` with a `ModelRunner` and register the `Mw` components
 `authorizer` and `validator` to be run by the ModelRunner.

```LiveScript
Middleware.register model: ModelRunner
model-middleware = new Middleware('model').use(authorizer).use(validator)
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
A typical runner such as `ModelRunner` (see *model-mw* project) extends `BaseRunner` to be specialized for operating with models.

When constructed, it can be passed a `on-success` function which is returned if all middlewares are run successfully.
It can also take an `on-error` function which is called when one or more middlewares cause an error.

The result of `run` determines if `on-success` or `on-error` is called, depending on whether `runner.errors` is empty or not.

```LiveScript
my-done-fun = ->
  "Success :)"

error-fun = ->
  error: true
  errors: @errors

mw.base     = new BaseMw name: 'my mw'
base-runner = new BaseRunner on-success: my-done-fun, on-error: error-fun
base-runner.use mw.base
base-runner.run!
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
Middleware.register model: ModelRunner

# creates a Middleware instance with registry for Mw components
middleware = new Middleware 'model'

# registers the authorizer mw-component
middleware.use authorizer
```

Enjoy!

## Related projects

Please see:

* model-mw
* authorization-mw
* validation-mw

## Testing

Using *mocha*

Run all test

`$ mocha`

Run particular test

`$ mocha test/middleware/runner/base_runner_test.js`

Easy :)

## Contribution

Please suggest improvements and help improve this project :)
# Middleware and Runners

This project contains basic Middleware and Runner classes.

The *BaseRunner* should be the base class for implementing most middleware runners (or simply called "runners").
Any runner can be configured to run one or more middlewares (*-Mw)

See authorize-mw for example. Should employ the `use` chain syntax,
known from Express middleware to assign middleware components to be used.

## Usage

Other middleware projects *-mw should leverage this basic middleware functionality.
the `index.ls` file exports the relevant API to external modules:

Here is an example of how to use the middleware from an external module:

```livescript
middleware = require 'middleware'
BaseRunner = middleware.BaseRunner
BaseMw     = middleware.BaseMw

class MySuperMwRunner extends BaseRunner
  (args) ->
    # ...
```

## Middleware

The middlewares are currently split into Runner and -Mw components.

The idea is that a `*-runner` can be defined (using base-runner as the "base") and will run a list of middlewares `*-mw`
components in succession.

See tests for usage examples.

## TODO

The `model_runner`, `model_config` and `simple-mw` should all be moved to the *model-mw* project.
They are here for now as examples of use...

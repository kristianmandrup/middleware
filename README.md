# Middleware

The `Middleware` class is a factory for creating a Middleware suite that contains a Runner and individual Mw components.

Here we create a `Middleware` with a `ModelRunner` and register the `Mw` components
 `authorizer` and `validator` to be run by the ModelRunner.

```LiveScript
model-middleware = new Middleware('model').use(authorizer).use(validator)
```

## BaseRunner

The `BaseRunner` is a base class that provides the base functionality for any middleware runner.
A typical runner such as `ModelRunner` (see *model-mw* project) extends `BaseRunner` to be specialized for operating with models.

## BaseMw

The `BaseMw` is a base class for any Mw-component (middleware component) . Each Mw-component is
assigned a runner which is responsible for running the components and maintains the global middleware
state (including the result of running each Mw-component)

## Registry

A Registry is used to register (store) a set of Middleware components for a given Runner.

Create registry with empty `middlewares` object

```LiveScript
registry = new Registry
registry.register authorizer
```

It is used internally by Middleware when `use` is called:

Registers authorizer

```LiveScript
# creates a new Middleware instance with an empty registry for Mw components
middleware = new Middleware 'model'

# registers the authorizer (AuthorizationMw instance) in the empty registry
middleware.use authorizer)
```

# Middleware and Runners

Other middleware projects *-mw should leverage this basic middleware functionality

## TODO

The model_runner and model_config should be moved to *model-mw* project

## Middleware

The middlewares are currently split into Runner and -Mw components.

The idea is that a *-runner can be defined (using base-runner as the "base") and will run a list of middlewares (*-mw)
in succession.

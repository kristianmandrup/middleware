_ = require 'prelude-ls'

# stores a set of middlewares for a given runner
class MiddlewareRegistry
  @middlewares = {}

  @middleware-list = ->
    @@middlewares.values!

  @get = (name) ->
    @@middlewares[name]

  @at = (index) ->
    @@middleware-list[name]

  @register = (middleware) ->
    if _.is-type('Object', middleware) and middleware.run
      @@middlewares.push middleware
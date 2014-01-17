rek       = require 'rekuire'
requires  = rek 'requires'

_         = require 'prelude-ls'
lo        = require 'lodash'

Debugger = requires.file 'debugger'

# stores a set of middlewares for a given runner
module.exports = class MiddlewareRegistry implements Debugger
  ->
    @middlewares = {}

  middleware-list: ->
    _.values @middlewares

  get: (name) ->
    @middlewares[name]

  at: (index) ->
    @middleware-list[name]

  register: (middleware) ->
    unless _.is-type('Object', middleware) and middleware.run?
      throw Error "Middleware component must be an Object with a run method, was: #{middleware}"

    @middlewares[middleware.name] = middleware

lo.extend MiddlewareRegistry, Debugger
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
    return void if @middleware-list!.length is 0
    @middleware-list![index]

  clean: ->
    @middlewares = {}

  register: (middleware, name) ->
    @debug 'register', middleware
    name ||= middleware.name
    unless _.is-type('Object', middleware) and middleware.run?
      console.log "middleware", middleware
      throw Error "Middleware component must be an Object with a run method, was: #{middleware}"

    @middlewares[name] = middleware
    @debug 'registered', name

lo.extend MiddlewareRegistry, Debugger
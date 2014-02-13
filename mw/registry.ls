requires  = require '../requires'

_         = require 'prelude-ls'
lo        = require 'lodash'

Debugger = requires.file 'debugger'

# stores a set of middlewares for a given runner
module.exports = class MiddlewareRegistry implements Debugger
  ->
    @middlewares = {}
    @map = {}

  middleware-list: ->
    _.values @middlewares

  get: (name) ->
    @middlewares[name]

  get-mapped: (mw-name) ->
    reg-name = @map[mw-name]
    unless @middlewares[reg-name]
      throw Error "No middleware named #{mw-name} has been registered in this registry: #{@}"
    @middlewares[reg-name]

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

    @map[middleware.name] = name
    @middlewares[name] = middleware
    @debug 'registered', name

lo.extend MiddlewareRegistry, Debugger
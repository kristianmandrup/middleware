rek       = require 'rekuire'
requires  = rek 'requires'

_         = require 'prelude-ls'
lo        = require 'lodash'

Debugger = requires.file 'debugger'

# stores a set of middlewares for a given runner
module.exports = class MiddlewareRegistry implements Debugger
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

lo.extend MiddlewareRegistry, Debugger
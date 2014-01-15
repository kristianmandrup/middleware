_         = require 'prelude-ls'
rek       = require 'rekuire'
requires  = rek 'requires'

Debugger            = requires.file 'debugger'

MiddlewareRegistry  = requires.file 'mw/registry'

module.exports = class BaseRunner implements Debugger
  (@done-fun) ->
    # index of current middle-ware running
    @index = 0

    # setup function to run if all middleware is passed through
    unless _.is-type 'Function', @done-fun
      @done-fun = @@done-fun

    @registry = new MiddlewareRegistry

  name: 'basic'

  @done-fun = ->
    true

  middlewares: []

  next: ->
    nextIndex = @index++

    if @middlewares.length >= nextIndex
      nextMiddleware = @middlewares nextIndex
      nextMiddleware.run @
    else
      doneFun!
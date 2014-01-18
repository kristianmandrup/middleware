_         = require 'prelude-ls'
rek       = require 'rekuire'
requires  = rek 'requires'

Debugger            = requires.file 'debugger'

MiddlewareRegistry  = requires.file 'mw/registry'

# TODO: Should save result of each component in result list, including errors
module.exports = class BaseRunner implements Debugger
  (@done-fun) ->
    # index of current middle-ware running
    @index = 0

    # setup function to run if all middleware is passed through
    unless _.is-type 'Function', @done-fun
      @done-fun = @@done-fun

    @registry = new MiddlewareRegistry

  @done-fun = ->
    success: true
    errors:  {}

  results: {}

  middlewares: ->
    @registry.middlewares

  middleware-list: ->
    @registry.middleware-list!

  current-middleware: ->
    @middleware-list![@index]

  add-result: (result) ->
    @results[@current-middleware!.name] = result

  run-next-mw: ->
    @middleware-list.length >= @next-index

  # return next index
  next-index: ->
    @index ||= 0
    @index +1

  # increase number of middleware index
  inc-index: ->
    @index ||= 0
    @index++

  run: ->
    if @run-next-mw!
      @add-result @run-next!
      @inc-index!
      @run
    else
      @done-fun!

  run-next: ->
    @next-mw!.run @

  next-mw: ->
    @registry.at(@next-index)
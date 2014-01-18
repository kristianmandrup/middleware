_         = require 'prelude-ls'
rek       = require 'rekuire'
requires  = rek 'requires'

Debugger            = requires.file 'debugger'

MiddlewareRegistry  = requires.file 'mw/registry'

# TODO: Should save result of each component in result list, including errors
module.exports = class BaseRunner implements Debugger
  (@context) ->
    # index of current middle-ware running
    @index = 0

    if _.is-type 'Object', @context
      done-fun = @context.done-fun
      # setup function to run if all middleware is passed through
      if  _.is-type 'Function', done-fun
        @done-fun = done-fun

    @done-fun ||= @@done-fun
    @registry = new MiddlewareRegistry

  @done-fun = ->
    success: @success
    errors:  @errors

  use: (middleware) ->
    @registry.register middleware

  clean: ->
    @results  = {}
    @index    = 0

  success:  true
  errors:   []

  results: {}

  middlewares: ->
    @registry.middlewares

  middleware-list: ->
    @registry.middleware-list!

  current-middleware: ->
    @middleware-list![@index]

  add-result: (result) ->
    @results[@current-middleware!.name] = result

  run-mw: ->
    @middleware-list!.length > @index

  # return next index
  next-index: ->
    @index + 1

  # increase number of middleware index
  inc-index: ->
    @index++

  run: ->
    if @run-mw!
      @add-result @run-current!
      @inc-index!
      @run!
    @done-fun!

  run-current: ->
    @current-mw!.run @

  current-mw: ->
    @registry.at(@index)
_         = require 'prelude-ls'
lo        = require 'lodash'
rek       = require 'rekuire'
requires  = rek 'requires'

Debugger            = requires.file 'debugger'
MiddlewareRegistry  = requires.file 'mw/registry'

module.exports = class BaseRunner implements Debugger
  (@context) ->
    # index of current middle-ware running
    @index = 0

    if _.is-type 'Object', @context
      done-fun = @context.done-fun
      error-fun = @context.error-fun
      # setup function to run if all middleware is passed through
      if  _.is-type 'Function', done-fun
        @done-fun = done-fun

      if  _.is-type 'Function', error-fun
        @error-fun = error-fun

    @done-fun  ||= @@done-fun
    @error-fun ||= @@error-fun

    @registry = new MiddlewareRegistry

  @done-fun = ->
    success: @success
    errors:  @errors
    results: @results

  @error-fun = ->
    @errors

  use: (middleware) ->
    @registry.register middleware

  clean: ->
    @results  = {}
    @index    = 0
    @success  = true
    @errors   = {}

  success:  true
  errors:   {}

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
    @result!

  result: ->
    if @has-errors!
      @error-fun!
    else
      @done-fun!

  has-errors: ->
    not lo.is-empty @errors

  run-current: ->
    @current-mw!.run @

  current-mw: ->
    @registry.at(@index)
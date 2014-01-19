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
    @aborted = false

    if _.is-type 'Object', @context
      success-fun = @context.on-success
      error-fun   = @context.on-error
      # setup function to run if all middleware is passed through
      if  _.is-type 'Function', success-fun
        @on-success = success-fun

      if  _.is-type 'Function', error-fun
        @on-error   = error-fun

    @on-success ||= @@on-success
    @on-error   ||= @@on-error

    @registry = new MiddlewareRegistry

  @on-success = ->
    success: @success
    errors:  @errors
    results: @results

  @on-error = ->
    @errors

  use: (middleware) ->
    middleware.runner = @
    @registry.register middleware
    @

  abort: ->
    @aborted = true
    @success = false
    @aborted-by = @current-middleware!.name

  error: (msg) ->
    @errors[@current-middleware!.name] ||= []
    @errors[@current-middleware!.name].push msg

  # override as you like!
  is-success: ->
    @success = true

  clean: ->
    @results  = {}
    @index    = 0
    @success  = true
    @errors   = {}
    @aborted  = false

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

  can-run-mw: ->
    return false if @aborted
    @middleware-list!.length > @index

  # return next index
  next-index: ->
    @index + 1

  # increase number of middleware index
  inc-index: ->
    @index++

  run: ->
    @run-mw! if @can-run-mw!
    @result!

  run-mw: ->
    result = @run-current-mw!
    return false if @aborted
    @add-result result
    @inc-index!
    @run!

  result: ->
    if @has-errors!
      @on-error!
    else
      @on-success!

  has-errors: ->
    not lo.is-empty @errors

  run-current-mw: ->
    @current-mw!.run @


  current-mw: ->
    @registry.at @index
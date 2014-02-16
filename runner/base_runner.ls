_         = require 'prelude-ls'
lo        = require 'lodash'

requires  = require '../requires'
require 'sugar'

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
    lo.extend {success: @success, results: @results}, @all-errors

  @on-error = ->
    @all-errors

  all-errors: ->
    errors: @errors
    localized-errors: @localized-errors

  use-mw: (mw, name) ->
    # @debug "use-mw", mw, name
    get-mw = (mw, runner) ->
      switch typeof mw
      case 'object'
        mw.runner = runner
        mw
      case 'function'
        new mw runner: runner
      default
        throw Error "mw must be Mw instance or Mw class, was: #{typeof mw}, #{mw}"

    mw = get-mw(mw, @)
    @registry.register mw, name
    @

  use: ->
    self = @
    mw-components = switch typeof arguments
    case 'object'
      _.values(arguments)
    default
      arguments

    mw-components = mw-components.flatten!

    if lo.is-empty mw-components
      throw Error "You must pass one or more arguments with Mw-components to be used, was: #{arguments}"

    mw-components.each (mw) ->
      switch typeof mw
      case 'object'
        if mw.run?
          self.use-mw mw
        else
          _.keys(mw).each (key) ->
            self.use-mw mw[key], key
      default
        throw Erorr "Not a valid mw-component, was: #{typeof mw} #{mw}"
    @

  abort: ->
    @aborted = true
    @failure!
    @aborted-by = @current-middleware!.name

  error: (msg) ->
    @errors[@current-middleware!.name] ||= []
    @errors[@current-middleware!.name].push msg

  # alias
  add-error: (msg) ->
    @error msg

  localized-error (msg) ->
    @localized-errors[@current-middleware!.name] ||= []
    @localized-errors[@current-middleware!.name].push msg

  # alias
  add-localized-error: (msg) ->
    @localized-error msg

  is-success: ->
    @success is true

  is-failure: ->
    not @is-success!

  failure: ->
    @success = false

  successful: ->
    @success = true

  clean: ->
    @results  = {}
    @index    = 0
    @success  = true
    @errors   = {}
    @localized-errors = {}
    @aborted  = false
    @context  = {}

  success:  true
  errors:   {}
  localized-errors: {}

  results: {}

  middlewares: ->
    @registry.middlewares

  middleware-list: ->
    @registry.middleware-list!

  current-middleware: ->
    @middleware-list![@index]

  add-result: (result) ->
    name = @registry.map[@current-middleware!.name]
    @results[name] = result

  can-run-mw: ->
    return false if @aborted
    @middleware-list!.length > @index

  # return next index
  next-index: ->
    @index + 1

  # increase number of middleware index
  inc-index: ->
    @index++

  run: (ctx) ->
    @debug 'run', ctx
    @run-mw ctx if @can-run-mw!
    @result!

  run-mw: (ctx) ->
    result = @current-mw-result ctx
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

  run-current-mw: (ctx) ->
    mw = @current-mw!
    mw.init!
    @debug 'run-current-mw ctx', ctx
    ctx = @smart-merge ctx
    @debug 'smart-merged ctx to run mw', ctx, mw
    mw.run ctx

  smart-merge: (ctx) ->
    ctx

  current-mw-result: (ctx) ->
    res = @run-current-mw ctx
    switch res
    case void
      @current-mw!.result
    else
      res

  current-mw: ->
    @registry.at @index
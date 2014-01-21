_         = require 'prelude-ls'
lo        = require 'lodash'
rek       = require 'rekuire'
requires  = rek 'requires'
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
    success: @success
    errors:  @errors
    results: @results

  @on-error = ->
    @errors

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

  abort: ->
    @aborted = true
    @failure!
    @aborted-by = @current-middleware!.name

  error: (msg) ->
    @errors[@current-middleware!.name] ||= []
    @errors[@current-middleware!.name].push msg

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
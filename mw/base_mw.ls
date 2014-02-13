_         = require 'prelude-ls'
requires  = require '../requires'

require 'sugar'

Debugger = requires.file 'debugger'

module.exports = class BaseMw implements Debugger
  (@context) ->
    @context ||= {}
    @set-runner!
    @set-name!

  clean: ->
    @context = {}

  init: ->
    @result = void

  set-runner: ->
    if @context.runner? and @context.runner.run-mw?
      @runner = @context.runner

  set-name: ->
    if _.is-type 'String', @context.name
      @name = @context.name
    @name ||= @constructor.display-name.dasherize!

  error: (msg) ->
    @runner.error msg

  abort: ->
    @runner.abort!

  aborted: ->
    @runner.aborted

  has-errors: ->
    @runner.has-errors!

  is-success: ->
    @runner.is-success!

  is-failure: ->
    @runner.is-failure!

  failure: ->
    @runner.failure!

  successful: ->
    @runner.successful!

  # by default just returns true :)
  run: (ctx) ->
    true
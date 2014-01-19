_         = require 'prelude-ls'
rek       = require 'rekuire'
requires  = rek 'requires'

Debugger = requires.file 'debugger'

# TODO: why not merge this class with BaseMW or move to ModelMw ???
module.exports = class BaseMw implements Debugger
  (@context) ->
    if _.is-type 'Object' @context
      if @context.runner?
        @runner = @context.runner

      if _.is-type 'String', @context.name
        @name = @context.name

    @name ||= @constructor.display-name

  error: (msg) ->
    @runner.error msg

  abort: ->
    @runner.abort!

  success: ->
    @runner.is-success!

  run: ->
    success: true
    errors: {}
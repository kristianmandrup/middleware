_         = require 'prelude-ls'
rek       = require 'rekuire'
requires  = rek 'requires'

Debugger = requires.file 'debugger'

# TODO: why not merge this class with BaseMW or move to ModelMw ???
module.exports = class BaseMw implements Debugger
  (@context) ->
    unless @context.runner?
      throw Error "Context must have a runner"

    @runner = @context.runner

    if _.is-type 'String', @context.name
      @name = name

    @name ||= @constructor.display-name

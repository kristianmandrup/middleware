_         = require 'prelude-ls'
rek       = require 'rekuire'
requires  = rek 'requires'

Debugger = requires.file 'debugger'

# TODO: why not merge this class with BaseMW or move to ModelMw ???
module.exports = class BaseMw implements Debugger
  (@context, @name) ->
    unless @context.runner?
      throw Error "Context must have a runner"

    @runner = @context.runner

    unless _.is-type 'String', @name
      @name = @@name

  name = 'Middleware - no name'

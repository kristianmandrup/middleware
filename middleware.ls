rek         = require 'rekuire'
requires    = rek 'requires'

_           = require 'prelude-ls'
lo          =   require 'lodash'

Debugger            = requires.file 'debugger'
BaseRunner          = requires.file 'runner/base_runner'
MiddlewareRegistry  = requires.file 'mw/registry'

module.exports = class Middleware implements Debugger
  (@context) ->
    unless _.is-type 'Object', context
      throw Error "Context must be an Object, was: #{typeof context}, #{context}"

    @runner = context.runner
    @runner ||= @@default-runner context
    @index  = 0
    @registry = @runner.registry

  @default-runner = (context) ->
    new BaseRunner context

  use: (middleware) ->
    @registry.register middleware

  run-next-mw: (index) ->
    @middleware-list.length >= next-index

  # return next index
  next-index: ->
    @index ||= 0
    @index +1

  # increase number of middleware index
  inc-index: ->
    @index ||= 0
    @index++

  run: ->
    if @run-next-mw then @run-next! else @done-fun!
    @inc-index!

  run-next: ->
    @registry.at(@next-index).run @runner
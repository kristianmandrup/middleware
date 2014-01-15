rek         = require 'rekuire'
requires    = rek 'requires'

_           = 'prelude-ls'

MiddlewareRegistry  = requires.file 'middelware_registry'
BaseRunner          = requires.file 'base_runner'

class Middleware
  (@context) ->
    unless _.is-type 'Object', context
      throw Error "Context must be an Object, was: #{typeof context}, #{context}"

    @runner = context.runner
    @runner ||= @@default-runner context
    @index  = 0

  @default-runner = (context) ->
    new BaseRunner context

  use: (middleware) ->
    @registry!.register middleware

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
    if run-next-mw then run-next! else @done-fun!
    inc-index!

  run-next: ->
    @registry.at(next-index).run @runner
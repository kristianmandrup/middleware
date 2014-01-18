rek         = require 'rekuire'
requires    = rek 'requires'

_           = require 'prelude-ls'
lo          =   require 'lodash'

Debugger            = requires.file 'debugger'
BaseRunner          = requires.file 'runner/base_runner'
MiddlewareRegistry  = requires.file 'mw/registry'

module.exports = class Middleware implements Debugger
  (@context) ->
    _.last arguments
    if _.is-type('String', @context)
      runner-class = @@get-registered @context
      @context = runner: new runner-class

    unless _.is-type 'Object', @context
      throw Error "Context must be an Object, was: #{typeof @context}, #{@context}"

    @runner = @context.runner
    @runner ||= @@default-runner @context
    @registry = @runner.registry

  @default-runner = (context) ->
    new BaseRunner context

  use: (middleware) ->
    @registry.register middleware

  run: ->
    @runner.run!

  @get-registered = (name) ->
    unless @@runners[name]
      throw Error "No such pre-registered runner #{name}, must be one of: #{@@runners}"
    @@runners[name]

  @runners = {}

  @register = (runners) ->
    unless _.is-type 'Object', runners
      throw Error "to register runners pass a runners hash, was: #{runners}"
    @@runners = runners


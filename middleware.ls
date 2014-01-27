rek         = require 'rekuire'
requires    = rek 'requires'

_           = require 'prelude-ls'
lo          =   require 'lodash'
require 'sugar'

Debugger            = requires.file 'debugger'
BaseRunner          = requires.file 'runner/base_runner'
MiddlewareRegistry  = requires.file 'mw/registry'

module.exports = class Middleware implements Debugger
  (@context) ->
    if _.is-type('String', @context)
      ctx = _.last(arguments) if _.is-type 'Object', _.last(arguments)
      name = @context
      runner-class = @@get-registered name
      @context = runner: new runner-class ctx

    unless _.is-type 'Object', @context
      throw Error "Context must be an Object, was: #{typeof @context}, #{@context}"

    @runner = @context.runner
    @runner ||= @@default-runner @context
    @registry = @runner.registry

  @default-runner = (context) ->
    new BaseRunner context

  use: ->
    @runner.use _.values(arguments).flatten!
    @

  results: ->
    @runner.results

  run: ->
    @runner.run!

  clean: ->
    @runner.clean!

  @get-registered = (name) ->
    unless @@runners[name]
      throw Error "No such pre-registered runner #{name}, must be one of: #{@@runners}"
    @@runners[name]

  @runners = {}

  @register = (runners) ->
    unless _.is-type 'Object', runners
      throw Error "to register runners pass a runners hash, was: #{runners}"
    @@runners = runners


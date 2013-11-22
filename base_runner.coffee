require('rubyjs')
$ = require "jquery"
type = require "../util/type"

module.exports = ->
  name: 'basic'
  runner: (args) ->
    @baserun(args)
  baserun: (args) ->
    # index of current middle-ware running
    @index = 0

    console.log "Base runner!!!"

    lastArg = R(arguments).last or {}

    # setup function to run if all middleware is passed through
    @doneFun = if (type(lastArg) == 'function') then lastArg else @defaultDoneFun
    @

  middlewares: []
  use: (middleware) ->
    if type(middleware) == 'object'
      @middlewares.push middleware
    else
      throw "Not middleware: #{middleware}"

  run: ->
    console.log "Time to run: #{@name}"
    @next()

  wasLastStep: (nextIndex) ->
    nextIndex >= @middlewares.length

  next: ->
    throw "Index not set, was: #{@index}" unless @index >= 0

    nextIndex = @index++

    return @doneFun() if @wasLastStep(nextIndex)

    console.log @middlewares, nextIndex

    nextMiddleware = @middlewares[nextIndex]

    throw "Missing run method on mw: #{nextMiddleware}" unless nextMiddleware.run

    # pass runner to middleware
    nextMiddleware.run runner: @
    @next()


  # default empty fun if none provided
  defaultDoneFun: ->
    console.log 'DONE'
    true


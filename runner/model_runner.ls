BaseRunner = require './base_runner'
inflection = require 'inflection'
$ = require 'jquery'

module.exports = ->
  base = BaseRunner()

  $.extend {}, base,
    name: 'model'
    runner: (args) ->
      # index of current middle-ware running

      # TODO: Use Coffee Class and proto inheritance
      @baserun(args)

      argsObj = arguments[0]

      @model = argsObj['model']
      @data = argsObj['data']

      throw "Missing model in arguments" unless @model

      # @collection = R(@model).pluralize
      @collection = inflection.pluralize @model

      console.log "Collection", @collection
      @
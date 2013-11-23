# Validator = require 'validator'
BaseMw = require './base_mw'

module.exports = class SimpleMw extends BaseMw
  (context) ->
    console.log "context:", context

    super context

    @context = context

    throw Error "Context must have a runner" unless @context.runner?

    @runner = @context.runner

    throw Error "Runner must have a collection" unless @runner.collection?

    @collection = @runner.collection
    @model = @runner.model
    @data = @runner.data

#    validator = Validator.getFor(@model)
#
#    # default: can be customized to be context sensitive
#    validator.validate @data, (err, result) ->
#      console.log "validation:", err, result

  name: 'simple'

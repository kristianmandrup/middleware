BaseMw = require './base_mw'

# TODO: why not merge this class with BaseMW or move to ModelMw ???
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

  name: 'simple'

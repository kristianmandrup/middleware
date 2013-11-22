Validator = require('../middleware/validator')()

module.exports =  ->
  name: 'simple'
  run: (context) ->
    @context = context
    @runner = context.runner
    @collection = @runner.collection
    @model = @runner.model
    @data = @runner.data

    console.log "#{@name} middleware is being run with:", @runner.name

    validator = Validator.getFor(@model)
    # default: can be customized to be context sensitive
    validator.validate @data, (err, result) ->
      console.log "validation:", err, result
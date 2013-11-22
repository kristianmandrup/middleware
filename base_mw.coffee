require('../module')('MiddleWare')

class MiddleWare.Base
  constructor: (name) ->
    @name = name
    console.log "Base #{@name}"

module.exports = MiddleWare.Base
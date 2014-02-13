requires  = require './requires'

module.exports =
  Mw:
    base      :   requires.file 'mw/base_mw'
    registry  :   requires.file 'mw/registry'

  Runner      :
    base  :   requires.file 'runner/base_runner'

  middleware  : (ctx) ->
    new Middleware ctx

  Middleware  : requires.file 'middleware'
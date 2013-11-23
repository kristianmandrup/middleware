_ = require 'prelude-ls'

module.exports = class BaseRunner
  (args) ->
    # index of current middle-ware running
    @index = 0
    lastArg = _.last arguments or {}

    console.log "lastArg", lastArg

    # setup function to run if all middleware is passed through
    @doneFun = if _.is-type 'Function', lastArg then lastArg else @defaultDoneFun

  name: 'basic'


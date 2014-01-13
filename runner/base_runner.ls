_ = require 'prelude-ls'

module.exports = class BaseRunner implements Debugger
  (args) ->
    # index of current middle-ware running
    @index = 0
    lastArg = _.last arguments or {}

    @debug "lastArg", lastArg

    # setup function to run if all middleware is passed through
    @doneFun = if _.is-type 'Function', lastArg then lastArg else @defaultDoneFun

  name: 'basic'


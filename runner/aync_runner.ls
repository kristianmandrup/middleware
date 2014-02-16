/**
 * User: kmandrup
 * Date: 16/02/14
 * Time: 18:53
 */

# TODO: Please help ;)

_         = require 'prelude-ls'
lo        = require 'lodash'

requires  = require '../requires'
require 'sugar'

Debugger            = requires.file 'debugger'
MiddlewareRegistry  = requires.file 'mw/registry'

# TODO: needs development and testing...
module.exports = class AsyncRunner extends BaseRunner
  # call with config: {async: {defer: my-defer-meth}}} to
  # to configure defer method for this runner instance
  (@context) ->
    super ...

  # default promise defer config
  @defer-fun = ->
    Q.defer

  # TODO: override with async promise flow
  run: (ctx) ->
    @debug 'run', ctx
    @run-mw ctx if @can-run-mw!
    @result!

  # TODO: override with async promise flow?
  can-run-mw: ->
    return false if @aborted
    @middleware-list!.length > @index

  # TODO: override with async promise flow?
  run-mw: (ctx) ->
    result = @current-mw-result ctx
    return false if @aborted
    @add-result result
    @inc-index!
    @run!

  current-mw-result: (ctx) ->
    res = @run-current-mw ctx
    switch res
    case void
      @current-mw!.result
    else
      res


require! '../../test_setup'

SimpleMw      = require '../../../mw/simple_mw'
ModelRunner   = require '../../../runner/model_runner'

class User
  (@name) ->

describe 'simple middleware' ->
  var mw, runner, user

  # function to be assigned runner, to be called when runner is done
  doneFun = ->
    'done :)'

  before ->
    user    := new User 'kris'
    runner  := new ModelRunner data: user
    mw      := new SimpleMw runner: runner

  specify 'should be a BaseMw' ->
    mw.constructor.should.be.eql SimpleMw

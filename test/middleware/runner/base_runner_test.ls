require! '../../test_setup'
BaseRunner = require '../../../runner/base_runner'

describe 'base runner' ->
  var runner

  doneFun = ->
    'done :)'

  before ->
    runner := new BaseRunner doneFun

  specify 'should be a BaseRunner' ->
    runner.constructor.should.be.eql BaseRunner

  specify 'should have assigned doneFun function' ->
    runner.doneFun!.should.be.eql doneFun!
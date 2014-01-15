_         = require 'prelude-ls'
rek       = require 'rekuire'
requires  = rek 'requires'

requires.test 'test_setup'

BaseMw       = requires.file 'mw/base_mw'
BaseRunner   = requires.file 'runner/base_runner'

describe 'Middleware' ->
  var ctx

  # function to be assigned runner, to be called when runner is done
  doneFun = ->
    'done :)'

  describe 'class methods' ->
    describe 'default-runner' ->
      specify 'is a BaseRunner' ->
        Middleware.default-runner.constructor.should.be.eql BaseRunner


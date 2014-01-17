_         = require 'prelude-ls'
rek       = require 'rekuire'
requires  = rek 'requires'

requires.test 'test_setup'

BaseMw       = requires.file 'mw/base_mw'
BaseRunner   = requires.file 'runner/base_runner'
Middleware   = requires.file 'middleware'

describe 'Middleware' ->
  var ctx
  var middleware

  # function to be assigned runner, to be called when runner is done
  doneFun = ->
    'done :)'

  runners = {}
  mw      = {}

  describe 'class methods' ->
    describe 'default-runner' ->
      specify 'is a BaseRunner' ->
        Middleware.default-runner!.constructor.should.be.eql BaseRunner

  describe 'instance' ->
    var runner-ctx

    describe 'create' ->
      before ->
        mw.simple     := new BaseMw
        runners.basic := new BaseRunner runner-ctx
        ctx           :=
          context: runners.basic
        middleware    := new Middleware ctx

      describe 'runner' ->
        specify 'sets runner' ->
          middleware.runner.should.eql runners.basic

      describe 'index' ->
        specify 'inits to 0' ->
          middleware.index.should.eql 0

    describe 'use' ->
      before ->
        middleware.use mw.simple

      specify 'registers component in registry' ->
        middleware.registry.should.eql 0

_         = require 'prelude-ls'
rek       = require 'rekuire'
requires  = rek 'requires'

requires.test 'test_setup'

BaseMw       = requires.file 'mw/base_mw'
BaseRunner   = requires.file 'runner/base_runner'

describe 'BaseMw' ->
  var ctx

  # function to be assigned runner, to be called when runner is done
  doneFun = ->
    'done :)'

  runners   = {}
  mw        = {}

  describe 'create' ->
    context 'runner' ->
      before ->
        runners.base  := new BaseRunner
        ctx           :=
          runner: runners.base

        mw.base       := new BaseMw ctx

      describe 'instance' ->
        specify 'is a BaseMw' ->
          mw.base.constructor.should.be.eql BaseMw

      describe 'context' ->
        specify 'should be set' ->
          mw.base.context.should.be.eql ctx

      describe 'name' ->
        specify 'should be set' ->
          mw.base.name.should.be.eql BaseMw.name

      describe 'runner' ->
        specify 'should be set' ->
          mw.base.runner.should.be.eql runners.base

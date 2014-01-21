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
          mw.base.name.should.be.eql 'base-mw'

      describe 'runner' ->
        specify 'should be set' ->
          mw.base.runner.should.be.eql runners.base

    describe 'error' ->
      context 'Mw-component run method causes error' ->
        before ->
          mw.base := new BaseMw
          runners.base.clean!
          runners.base.use mw.base
          mw.base.run = ->
            @error 'very bad stuff!'

          runners.base.run!

        specify 'adds to runner errors' ->
          runners.base.errors['base-mw'].should.eql ['very bad stuff!']

      context 'Mw-component run method causes two errors!' ->
        errors = {a: 'very bad stuff!', b: 'more baaaad'}
        before ->

          mw.base := new BaseMw
          runners.base.clean!
          runners.base.use mw.base
          mw.base.run = ->
            @error errors.a
            @error errors.b

          runners.base.run!

        specify 'adds to runner errors' ->
          runners.base.errors['base-mw'].should.eql [errors.a, errors.b]


    describe 'abort' ->
      context 'Mw-component run method causes error' ->
        before ->
          mw.base := new BaseMw
          mw.next := new BaseMw name: 'next'
          runners.base.clean!
          runners.base.use(mw.base).use(mw.next)
          mw.base.run = ->
            @abort!

          runners.base.run!

        describe 'mw-component' ->
          specify 'aborted is true' ->
            mw.base.aborted!.should.be.true

          specify 'has-errors is false' ->
            mw.base.has-errors!.should.be.false

          specify 'is-success is false' ->
            mw.base.is-success!.should.be.false

          specify 'is-failure is true' ->
            mw.base.is-failure!.should.be.true

        describe 'runner' ->
          specify 'aborted is true' ->
            runners.base.aborted.should.be.true

          specify 'aborted-by is BaseMw' ->
            runners.base.aborted-by.should.eql 'base-mw'

          specify 'index is still 0' ->
            runners.base.index.should.eql 0

          specify 'current-middleware is middleware which aborted: BaseMw' ->
            runners.base.current-middleware!.name.should.eql 'base-mw'
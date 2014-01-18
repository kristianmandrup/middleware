_         = require 'prelude-ls'
rek       = require 'rekuire'
requires  = rek 'requires'

requires.test 'test_setup'

BaseRunner  = requires.file 'runner/base_runner'
BaseMw      = requires.file 'mw/base_mw'

describe 'base runner' ->
  var runner

  base-runner = (ctx) ->
    new BaseRunner ctx

  runners = {}
  mw = {}

  done-fun = ->
    'done :)'

  context 'no custom done function' ->
    before ->
      runners.base := base-runner!

    specify 'should be a BaseRunner' ->
      runners.base.constructor.should.be.eql BaseRunner

    specify 'should have assigned default done-fun function' ->
      runners.base.done-fun!.success.should.be.true
      runners.base.done-fun!.errors.should.eql {}
      runners.base.done-fun!.results.should.eql {}

    describe 'results' ->
      specify 'should be empty' ->
        runners.base.results.should.eql {}

    describe 'middlewares' ->
      specify 'should be empty' ->
        runners.base.middlewares!.should.eql {}

    describe 'middleware-list' ->
      specify 'should be empty' ->
        runners.base.middleware-list!.should.eql []

  context 'custom done function' ->
    before ->
      runners.base := base-runner done-fun: done-fun

    specify 'should have assigned done-fun function' ->
      runners.base.done-fun!.should.eql done-fun!

  context 'data and custom done function' ->
    before ->
      runners.base := base-runner data: 'hello', done-fun: done-fun
      mw.base := new BaseMw
      runners.base.use mw.base

    describe 'middleware-list' ->
      specify 'should have 1 component' ->
        runners.base.middleware-list!.length.should.eql 1

      specify 'should have BaseMw component' ->
        runners.base.middleware-list!.should.not.eql []

    describe 'index' ->
      specify 'should be 0' ->
        runners.base.index.should.eql 0

    describe 'next-index' ->
      specify 'should be 1' ->
        runners.base.next-index!.should.eql 1

    describe 'run-mw' ->
      specify 'should be true' ->
        runners.base.run-mw!.should.be.true

    specify 'should have assigned done-fun function' ->
      runners.base.done-fun!.should.eql done-fun!

    specify 'should have assigned data' ->
      runners.base.context.data.should.eql 'hello'

    describe 'run' ->
      var result
      before ->
        result := runners.base.run!

      describe 'errors' ->
        specify 'should be empty' ->
          runners.base.errors.should.eql {}

      describe 'has-errors' ->
        specify 'should be false' ->
          runners.base.has-errors!.should.be.false

      specify 'should return done-fun result' ->
        result.should.eql done-fun!

    describe 'add-result' ->
      before ->
        runners.base.clean!
        runners.base.add-result 'a result'

      specify 'should include success' ->
        runners.base.results['BaseMw'].should.eql 'a result'

    describe 'results' ->
      before ->
        runners.base.clean!
        runners.base.run!

      specify 'should include success' ->
        runners.base.results['BaseMw'].success.should.be.true

    describe 'cause error' ->
      var errors

      before ->
        errors := {'error': 'oops!'}
        runners.base.clean!
        runners.base.errors = errors

      describe 'errors' ->
        specify 'should not be empty' ->
          runners.base.errors.should.eql errors

      describe 'has-errors' ->
        specify 'should be true' ->
          runners.base.errors.should.eql errors
          runners.base.has-errors!.should.be.true

      describe 'result' ->
        specify 'should return errors' ->
          runners.base.run!.should.eql errors
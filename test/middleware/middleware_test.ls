_         = require 'prelude-ls'
rek       = require 'rekuire'
requires  = rek 'requires'

requires.test 'test_setup'

assert = require('chai').assert
expect = require('chai').expect

BaseMw       = requires.file 'mw/base_mw'
BaseRunner   = requires.file 'runner/base_runner'
Middleware   = requires.file 'middleware'

describe 'Middleware' ->
  var ctx
  var middleware

  # function to be assigned runner, to be called when runner is done
  done-fun = ->
    'done :)'

  runners = {}
  mw      = {}

  describe 'class methods' ->
    describe 'default-runner' ->
      specify 'is a BaseRunner' ->
        Middleware.default-runner!.constructor.should.be.eql BaseRunner

    describe 'runners' ->
      specify 'is empty' ->
          Middleware.runners.should.eql {}

    describe 'register' ->
      context 'register base: BaseRunner' ->
        before ->
          Middleware.register base: BaseRunner

        specify 'registered BaseRunner as base' ->
            Middleware.runners.base.should.eql BaseRunner

  describe 'instance' ->
    var runner-ctx

    describe 'create' ->
      context 'BaseRunner registered, by name' ->
        before ->
          middleware    := new Middleware 'base'
          middleware.debug-on!

        describe 'runner' ->
          specify 'sets runner' ->
            middleware.runner.constructor.should.eql BaseRunner

      context 'BaseRunner with no mw components registered' ->
        before ->
          runners.basic := new BaseRunner runner-ctx
          ctx           :=
            runner: runners.basic
          middleware    := new Middleware ctx

        describe 'runner' ->
          specify 'sets runner' ->
            middleware.runner.should.eql runners.basic

        describe 'run' ->
          specify 'returns result of default done-fun' ->
              middleware.run!.should.eql BaseRunner.done-fun!

      context 'using registered base and passing ctx' ->
        before ->
          middleware    := new Middleware 'base', data: 'hello'
          middleware.debug-on!

        describe 'runner' ->
          specify 'sets runner' ->
            middleware.runner.constructor.should.eql BaseRunner

          specify 'runner has context' ->
            middleware.runner.context.should.eql data: 'hello'

          specify 'runner has context with data' ->
            middleware.runner.context.data.should.eql 'hello'


    describe 'use' ->
      context 'using simple mw' ->
        before ->
          mw.base = new BaseMw
          middleware.use mw.base
          runners.basic.done-fun = done-fun

        describe 'registered component' ->
          specify 'in registry middleware list' ->
            middleware.registry.middleware-list![0].should.eql mw.base

          specify 'in middlewares by name' ->
            middleware.registry.middlewares[mw.base.name].should.eql mw.base

        describe 'run' ->
          specify 'returns result of done-fun' ->
            middleware.run!.should.eql done-fun!

          describe 'results' ->
            before ->
              middleware.run!

            specify 'is not empty' ->
              middleware.results!.should.not.eql {}

            specify 'set by name of component' ->
              expect(middleware.results!['base']).should.not.eql void

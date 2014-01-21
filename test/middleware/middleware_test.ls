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
          # middleware.debug-on!

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

      context 'using registered base and passing ctx' ->
        before ->
          middleware    := new Middleware 'base', data: 'hello'
          # middleware.debug-on!

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

        describe 'registered component' ->
          specify 'in registry middleware list' ->
            middleware.registry.middleware-list![0].should.eql mw.base

          specify 'in middlewares by name' ->
            middleware.registry.middlewares[mw.base.name].should.eql mw.base

      context 'using hash of mw-components' ->
        before ->
          mw.base = new BaseMw
          mw.super = new BaseMw name: 'super-duper'
          middleware.debug-on!
          middleware.runner.debug-on!

          middleware.use basic: mw.base, super: mw.super

        describe 'registry' ->
          var registry
          before ->
            registry := middleware.runner.registry

          describe 'registered mw-components' ->
            specify 'should have basic BaseMw component' ->
              registry.get('basic').should.eql mw.base

            specify 'should have super BaseMw component' ->
              registry.get('super').should.eql mw.super

      context 'using list of mw-components' ->
        before ->
          mw.base = new BaseMw
          mw.super = new BaseMw name: 'super-duper'
          middleware.registry.clean!
          middleware.use mw.base, mw.super

        describe 'registry' ->
          var registry
          before ->
            registry := middleware.runner.registry

          describe 'registered mw-components' ->
            specify 'should have basic BaseMw components in register' ->
              registry.get('base-mw').should.eql mw.base

            specify 'should have super BaseMw components in register' ->
              registry.get('super-duper').should.eql mw.super

        describe 'run' ->
          var runner
          before ->
            mw.base = new BaseMw
            middleware.use mw.base
            runner := middleware.runner
            runner.on-success = done-fun
            runner.clean!


          describe 'runner' ->
            before ->
              runner.clean!

            specify 'has set on-success' ->
              runner.on-success.should.eql done-fun

            describe 'index' ->
              specify 'is 0' ->
                runner.index.should.eql 0

            describe 'middleware-list' ->
              specify 'is not empty' ->
                runner.middleware-list!.should.not.eql []

            describe 'can-run-mw' ->
              specify 'it has' ->
                runner.can-run-mw!.should.be.true

          specify 'returns result of done-fun' ->
            middleware.run!.should.eql done-fun!

          describe 'results' ->
            before ->
              middleware.run!

            specify 'is not empty' ->
              middleware.results!.should.not.be.empty

            specify 'set by name of component' ->
              middleware.results!['base-mw'].should.eql true

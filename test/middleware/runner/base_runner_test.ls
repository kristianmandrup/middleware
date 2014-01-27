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

    specify 'should have assigned default on-success function' ->
      runners.base.on-success!.success.should.be.true
      runners.base.on-success!.errors.should.eql {}
      runners.base.on-success!.results.should.eql {}

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
      runners.base := base-runner on-success: done-fun

    specify 'should have assigned done-fun function' ->
      runners.base.on-success!.should.eql done-fun!

    describe 'use' ->
      var registry

      context 'using simple mw' ->
        before ->
          mw.base = new BaseMw
          runners.base := base-runner on-success: done-fun
          runners.base.use mw.base
          registry := runners.base.registry

        describe 'registered component' ->
          specify 'in registry middleware list' ->
            registry.middleware-list![0].should.eql mw.base

          specify 'in middlewares by name' ->
            registry.middlewares[mw.base.name].should.eql mw.base

      context 'using hash of mw-components' ->
        var results

        before ->
          mw.base = new BaseMw
          mw.super = new BaseMw name: 'super-duper'
          runners.base := base-runner on-success: done-fun
          runners.base.use basic: mw.base, super: mw.super
          registry := runners.base.registry
          runners.base.run!
          results := runners.base.results

        describe 'registry' ->
          describe 'registered mw-components' ->
            specify 'should have basic BaseMw component' ->
              registry.get('basic').should.eql mw.base

            specify 'should have super BaseMw component' ->
              registry.get('super').should.eql mw.super

        describe 'results' ->
          specify 'has basic result' ->
            results['basic'].should.be.true

          specify 'has super result' ->
            results['super'].should.be.true

      context 'using chain of mw-components' ->
        before ->
          mw.base = new BaseMw
          mw.super = new BaseMw name: 'super-duper'
          runners.base := base-runner on-success: done-fun
          runners.base.use(mw.base).use(mw.super)
          registry := runners.base.registry

        describe 'registry' ->
          describe 'registered mw-components' ->
            specify 'should have basic BaseMw components in register' ->
              registry.get('base-mw').should.eql mw.base

            specify 'should have super BaseMw components in register' ->
              registry.get('super-duper').should.eql mw.super

      context 'using list of mw-components' ->
        before ->
          mw.base = new BaseMw
          mw.super = new BaseMw name: 'super-duper'
          runners.base := base-runner on-success: done-fun
          runners.base.use mw.base, mw.super
          registry := runners.base.registry

        describe 'registry' ->
          describe 'registered mw-components' ->
            specify 'should have basic BaseMw components in register' ->
              registry.get('base-mw').should.eql mw.base

            specify 'should have super BaseMw components in register' ->
              registry.get('super-duper').should.eql mw.super


  context 'data and custom done function' ->
    before ->
      runners.base := base-runner data: 'hello', on-success: done-fun
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

    describe 'can-run-mw' ->
      specify 'should be true' ->
        runners.base.can-run-mw!.should.be.true

    specify 'should have assigned done-fun function' ->
      runners.base.on-success!.should.eql done-fun!

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

      describe 'results' ->
        specify 'should have added the result' ->
          runners.base.results['base-mw'].should.eql 'a result'

    describe 'results' ->
      before ->
        runners.base.clean!
        runners.base.run!

      specify 'should be success (true)' ->
        runners.base.results['base-mw'].should.be.true

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

        specify 'aborted is true' ->
          runners.base.aborted.should.be.true

        specify 'success is false' ->
          runners.base.success.should.be.false

        specify 'aborted-by is BaseMw' ->
          runners.base.aborted-by.should.eql 'base-mw'

        specify 'index is still 0' ->
          runners.base.index.should.eql 0

        specify 'current-middleware is middleware which aborted: BaseMw' ->
          runners.base.current-middleware!.name.should.eql 'base-mw'

    describe 'is-success' ->
      context 'success is false' ->
        before ->
          mw.base := new BaseMw
          mw.next := new BaseMw name: 'next'
          runners.base.clean!
          runners.base.success = false
          runners.base.use(mw.base).use(mw.next)
          mw.base.run = ->
            @successful!

        specify 'success is false' ->
          runners.base.success.should.be.false

        context 'runner is run' ->
          before ->
            runners.base.run!

          specify 'success is true' ->
            runners.base.success.should.be.true

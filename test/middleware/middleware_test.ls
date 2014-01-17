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
  done-fun = ->
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
      context 'no mw components registered' ->
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

        describe 'run' ->
          specify 'returns result of default done-fun' ->
              middleware.run!.should.eql BaseRunner.done-fun!


    describe 'use' ->
      context 'using simple mw' ->
        before ->
          middleware.use mw.simple
          runners.basic.done-fun = done-fun

        describe 'registered component' ->
          specify 'in registry middleware list' ->
            middleware.registry.middleware-list![0].should.eql mw.simple

          specify 'in middlewares by name' ->
            middleware.registry.middlewares[mw.simple.name].should.eql mw.simple

        describe 'run' ->
          context '' ->
            before ->
              middleware.run!.should.eql done-fun!

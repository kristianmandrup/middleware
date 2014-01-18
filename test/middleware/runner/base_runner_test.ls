_         = require 'prelude-ls'
rek       = require 'rekuire'
requires  = rek 'requires'

requires.test 'test_setup'

BaseRunner = requires.file 'runner/base_runner'

describe 'base runner' ->
  var runner

  base-runner = (ctx) ->
    new BaseRunner ctx

  runners = {}

  done-fun = ->
    'done :)'

  context 'no custom done function' ->
    before ->
      runners.base := base-runner!

    specify 'should be a BaseRunner' ->
      runners.base.constructor.should.be.eql BaseRunner

    specify 'should have assigned doneFun function' ->
      runners.base.done-fun!.should.be.eql BaseRunner.done-fun!

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

    specify 'should have assigned doneFun function' ->
      runners.base.done-fun!.should.be.eql done-fun!

  context 'data and custom done function' ->
    before ->
      runners.base := base-runner data: 'hello', done-fun: done-fun

    specify 'should have assigned doneFun function' ->
      runners.base.done-fun!.should.be.eql done-fun!

    specify 'should have assigned data' ->
      runners.base.context.data.should.be.eql 'hello'

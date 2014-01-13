_         = require 'prelude-ls'
rek       = require 'rekuire'
requires  = rek 'requires'

requires.test 'test_setup'

BaseRunner = requires.file 'runner/base_runner'

describe 'base runner' ->
  var runner

  base-runner = (fun) ->
    new BaseRunner fun

  runners = {}

  context 'no custom done function' ->
    before ->
      runners.base := base-runner!

    specify 'should be a BaseRunner' ->
      runners.base.constructor.should.be.eql BaseRunner

    specify 'should have assigned doneFun function' ->
      runners.base.done-fun!.should.be.eql BaseRunner.done-fun!


  context 'custom done function' ->
    done-fun = ->
      'done :)'

    before ->
      runners.base := base-runner done-fun

    specify 'should have assigned doneFun function' ->
      runners.base.done-fun!.should.be.eql done-fun!

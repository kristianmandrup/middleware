_         = require 'prelude-ls'
rek       = require 'rekuire'
requires  = rek 'requires'

requires.test 'test_setup'

BaseMw              = requires.file 'mw/base_mw'
BaseRunner          = requires.file 'runner/base_runner'
MiddlewareRegistry  = requires.file 'mw/registry'

assert = require('chai').assert
expect = require('chai').expect

describe 'MiddlewareRegistry' ->
  var ctx

  # function to be assigned runner, to be called when runner is done
  doneFun = ->
    'done :)'

  registries    = {}
  mw            = {}

  registry = ->
    new MiddlewareRegistry

  base-mw = (ctx) ->
    new BaseMw ctx

  context 'empty registry' ->
    before ->
      registries.empty := registry!

    describe 'instance' ->
      specify 'is a MiddlewareRegistry' ->
        registries.empty.constructor.should.be.eql MiddlewareRegistry

    describe 'middlewares' ->
      specify 'is empty object' ->
        registries.empty.middlewares.should.be.eql {}

    describe 'middleware-list' ->
      specify 'is empty' ->
        registries.empty.middleware-list!.should.be.eql []

    describe 'get' ->
      specify 'returns void' ->
        expect(registries.empty.get 'BaseMw').to.equal void

    describe 'at' ->
      specify 'returns void' ->
        expect(registries.empty.at 0).to.equal void

    describe 'register' ->
      context 'registered BaseMw component (no name)' ->
        before ->
          ctx := data: {}
          mw.base         := base-mw ctx
          registries.base := registry!

          registries.base.register mw.base
          # registries.base.debug-on!

        describe 'middlewares' ->
          specify 'BaseMw is registered by classname: BaseMw' ->
            registries.base.middlewares['BaseMw'].should.be.eql mw.base

        describe 'middleware-list' ->
          specify 'has one item' ->
            registries.base.middleware-list!.length.should.eql 1

      describe 'get' ->
        specify 'returns BaseMw mw component' ->
          registries.base.get('BaseMw').should.eql mw.base

      describe 'at' ->
        specify 'returns BaseMw mw component' ->
          registries.base.at(0).should.eql mw.base

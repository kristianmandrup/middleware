_         = require 'prelude-ls'
rek       = require 'rekuire'
requires  = rek 'requires'

requires.test 'test_setup'

BaseMw              = requires.file 'mw/base_mw'
BaseRunner          = requires.file 'runner/base_runner'
MiddlewareRegistry  = requires.file 'middleware_registry'

describe 'MiddlewareRegistry' ->
  var ctx

  # function to be assigned runner, to be called when runner is done
  doneFun = ->
    'done :)'

  registries    = {}
  mw            = {}

  registry = ->
    new MiddlewareRegistry

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
        registries.empty.middleware-list.should.be.eql []

  context 'registered BaseMw' ->
    before ->
      ctx := data: {}

      registries.base := registry!
      mw.base         := new BaseMw ctx

    describe 'instance' ->
      specify 'is a MiddlewareRegistry' ->
        registries.base.constructor.should.be.eql MiddlewareRegistry

    describe 'middlewares' ->
      specify 'BaseMw: is BaseMw instance' ->
        registries.empty.middlewares['BaseMw'].should.be.eql mw.base

    describe 'middleware-list' ->
      specify 'has one element' ->
        registries.empty.middleware-list.length.should.be.eql 1

      specify 'has element BaseMw instance' ->
        registries.empty.middleware-list[0].should.be.eql mw.base

    describe 'register' ->
      before ->
        registries.base.register mw.base

      specify 'registers another base' ->
        registries.base.middleware-list.length.should.eql 2

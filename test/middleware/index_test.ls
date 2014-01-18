rek       = require 'rekuire'
requires  = rek 'requires'

requires.test 'test_setup'

_  = require 'prelude-ls'

expect = require('chai').expect
assert = require('chai').assert

middleware = requires.file 'index'

BaseMw      = middleware.Mw.base
Registry    = middleware.Mw.registry
BaseRunner  = middleware.Runner.base
Middleware  = middleware.Middleware

describe 'index' ->
  describe 'Mw' ->
    before ->
      console.log BaseMw
    specify 'base' ->
      BaseMw.display-name.should.eql 'BaseMw'

    specify 'registry' ->
      Registry.display-name.should.eql 'MiddlewareRegistry'

  describe 'Runner' ->
    specify 'base' ->
      BaseRunner.display-name.should.eql 'BaseRunner'

  describe 'middleware' ->
    specify 'is function' ->
      expect(_.is-type 'Function', middleware.middleware).to.be.true

  describe 'Middleware' ->
    specify 'is there' ->
      Middleware.display-name.should.eql 'Middleware'


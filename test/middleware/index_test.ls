rek       = require 'rekuire'
requires  = rek 'requires'

requires.test 'test_setup'

_  = require 'prelude-ls'

expect = require('chai').expect
assert = require('chai').assert

middleware = requires.file 'index'

describe 'index' ->
  describe 'Mw' ->
    specify 'base' ->
      middleware.Mw.base.should.not.eql void

    specify 'registry' ->
      middleware.Mw.registry.should.not.eql void

  describe 'Runner' ->
    specify 'base' ->
      middleware.Runner.base.should.not.eql void

  describe 'middleware' ->
    specify 'is function' ->
      expect(_.is-type 'Function', middleware.middleware).to.be.true

  describe 'Middleware' ->
    specify 'is there' ->
      middleware.Middleware.should.not.eql void


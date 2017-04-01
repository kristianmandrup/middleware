// Generated by LiveScript 1.2.0
(function(){
  var requires, _, expect, assert, middleware, BaseMw, Registry, BaseRunner, Middleware;
  requires = require('../../requires');
  requires.test('test_setup');
  _ = require('prelude-ls');
  expect = require('chai').expect;
  assert = require('chai').assert;
  middleware = requires.file('index');
  BaseMw = middleware.Mw.base;
  Registry = middleware.Mw.registry;
  BaseRunner = middleware.Runner.base;
  Middleware = middleware.Middleware;
  describe('index', function(){
    describe('Mw', function(){
      specify('base', function(){
        return BaseMw.displayName.should.eql('BaseMw');
      });
      return specify('registry', function(){
        return Registry.displayName.should.eql('MiddlewareRegistry');
      });
    });
    describe('Runner', function(){
      return specify('base', function(){
        return BaseRunner.displayName.should.eql('BaseRunner');
      });
    });
    describe('middleware', function(){
      return specify('is function', function(){
        return expect(_.isType('Function', middleware.middleware)).to.be['true'];
      });
    });
    return describe('Middleware', function(){
      return specify('is there', function(){
        return Middleware.displayName.should.eql('Middleware');
      });
    });
  });
}).call(this);
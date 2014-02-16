// Generated by LiveScript 1.2.0
(function(){
  var _, lo, requires, Debugger, MiddlewareRegistry, BaseRunner;
  _ = require('prelude-ls');
  lo = require('lodash');
  requires = require('../requires');
  require('sugar');
  Debugger = requires.file('debugger');
  MiddlewareRegistry = requires.file('mw/registry');
  module.exports = BaseRunner = (function(){
    BaseRunner.displayName = 'BaseRunner';
    var prototype = BaseRunner.prototype, constructor = BaseRunner;
    importAll$(prototype, arguments[0]);
    function BaseRunner(context){
      var successFun, errorFun;
      this.context = context;
      this.index = 0;
      this.aborted = false;
      if (_.isType('Object', this.context)) {
        successFun = this.context.onSuccess;
        errorFun = this.context.onError;
        if (_.isType('Function', successFun)) {
          this.onSuccess = successFun;
        }
        if (_.isType('Function', errorFun)) {
          this.onError = errorFun;
        }
        this.config = this.context.config;
      }
      this.onSuccess || (this.onSuccess = constructor.onSuccess);
      this.onError || (this.onError = constructor.onError);
      this.registry = new MiddlewareRegistry;
    }
    BaseRunner.onSuccess = function(){
      return lo.extend({
        success: this.success,
        results: this.results
      }, this.allErrors);
    };
    BaseRunner.onError = function(){
      return this.allErrors;
    };
    prototype.allErrors = function(){
      return {
        errors: this.errors,
        localizedErrors: this.localizedErrors
      };
    };
    prototype.useMw = function(mw, name){
      var getMw;
      getMw = function(mw, runner){
        switch (typeof mw) {
        case 'object':
          mw.runner = runner;
          return mw;
        case 'function':
          return new mw({
            runner: runner
          });
        default:
          throw Error("mw must be Mw instance or Mw class, was: " + typeof mw + ", " + mw);
        }
      };
      mw = getMw(mw, this);
      this.registry.register(mw, name);
      return this;
    };
    prototype.use = function(){
      var self, mwComponents;
      self = this;
      mwComponents = (function(args$){
        switch (typeof args$) {
        case 'object':
          return _.values(args$);
        default:
          return args$;
        }
      }(arguments));
      mwComponents = mwComponents.flatten();
      if (lo.isEmpty(mwComponents)) {
        throw Error("You must pass one or more arguments with Mw-components to be used, was: " + arguments);
      }
      mwComponents.each(function(mw){
        switch (typeof mw) {
        case 'object':
          if (mw.run != null) {
            return self.useMw(mw);
          } else {
            return _.keys(mw).each(function(key){
              return self.useMw(mw[key], key);
            });
          }
          break;
        default:
          throw Erorr("Not a valid mw-component, was: " + typeof mw + " " + mw);
        }
      });
      return this;
    };
    prototype.abort = function(){
      this.aborted = true;
      this.failure();
      return this.abortedBy = this.currentMiddleware().name;
    };
    prototype.error = function(msg){
      var ref$, key$;
      (ref$ = this.errors)[key$ = this.currentMiddleware().name] || (ref$[key$] = []);
      return this.errors[this.currentMiddleware().name].push(msg);
    };
    prototype.addError = function(msg){
      return this.error(msg);
    };
    prototype.localizedError = function(msg){
      var ref$, key$;
      (ref$ = this.localizedErrors)[key$ = this.currentMiddleware().name] || (ref$[key$] = []);
      return this.localizedErrors[this.currentMiddleware().name].push(msg);
    };
    prototype.addLocalizedError = function(msg){
      return this.localizedError(msg);
    };
    prototype.isSuccess = function(){
      return this.success === true;
    };
    prototype.isFailure = function(){
      return !this.isSuccess();
    };
    prototype.failure = function(){
      return this.success = false;
    };
    prototype.successful = function(){
      return this.success = true;
    };
    prototype.clean = function(){
      this.results = {};
      this.index = 0;
      this.success = true;
      this.errors = {};
      this.localizedErrors = {};
      this.aborted = false;
      return this.context = {};
    };
    prototype.success = true;
    prototype.errors = {};
    prototype.localizedErrors = {};
    prototype.results = {};
    prototype.middlewares = function(){
      return this.registry.middlewares;
    };
    prototype.middlewareList = function(){
      return this.registry.middlewareList();
    };
    prototype.currentMiddleware = function(){
      return this.middlewareList()[this.index];
    };
    prototype.lastMiddleware = function(){
      if (this.index > 0) {
        return this.middlewareList()[this.index(-1)];
      }
    };
    prototype.lastResult = function(){
      return this.resultOf(lastMiddleware());
    };
    prototype.resultOf = function(mw){
      var name;
      name = (function(){
        switch (typeof mw) {
        case 'object':
          return mw.name;
        case 'string':
          return mw;
        default:
          throw Error("Argument error: Must be a String or Mw-component, was: " + mw);
        }
      }());
      return this.results[name];
    };
    prototype.mwList = function(){
      return this.middlewareList();
    };
    prototype.currentMw = function(){
      return this.currentMiddleware();
    };
    prototype.lastMw = function(){
      return this.lastMiddleware();
    };
    prototype.addResult = function(result){
      var name;
      name = this.registry.map[this.currentMiddleware().name];
      return this.results[name] = result;
    };
    prototype.canRunMw = function(){
      if (this.aborted) {
        return false;
      }
      return this.middlewareList().length > this.index;
    };
    prototype.nextIndex = function(){
      return this.index + 1;
    };
    prototype.incIndex = function(){
      return this.index++;
    };
    prototype.run = function(ctx){
      this.debug('run', ctx);
      if (this.canRunMw()) {
        this.runMw(ctx);
      }
      return this.result();
    };
    prototype.runMw = function(ctx){
      var result;
      result = this.currentMwResult(ctx);
      if (this.aborted) {
        return false;
      }
      this.addResult(result);
      this.incIndex();
      return this.run();
    };
    prototype.result = function(){
      if (this.hasErrors()) {
        return this.onError();
      } else {
        return this.onSuccess();
      }
    };
    prototype.hasErrors = function(){
      return !lo.isEmpty(this.errors);
    };
    prototype.runCurrentMw = function(ctx){
      var mw;
      mw = this.currentMw();
      mw.init();
      this.debug('run-current-mw ctx', ctx);
      ctx = this.smartMerge(ctx);
      this.debug('smart-merged ctx to run mw', ctx, mw);
      return mw.run(ctx);
    };
    prototype.smartMerge = function(ctx){
      return ctx;
    };
    prototype.currentMwResult = function(ctx){
      var res;
      res = this.runCurrentMw(ctx);
      switch (res) {
      case void 8:
        return this.currentMw().result;
      default:
        return res;
      }
    };
    prototype.currentMw = function(){
      return this.registry.at(this.index);
    };
    return BaseRunner;
  }(Debugger));
  function importAll$(obj, src){
    for (var key in src) obj[key] = src[key];
    return obj;
  }
}).call(this);

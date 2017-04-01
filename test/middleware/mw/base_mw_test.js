// Generated by LiveScript 1.2.0
(function(){
  var _, requires, BaseMw, BaseRunner;
  _ = require('prelude-ls');
  requires = require('../../../requires');
  requires.test('test_setup');
  BaseMw = requires.file('mw/base_mw');
  BaseRunner = requires.file('runner/base_runner');
  describe('BaseMw', function(){
    var ctx, doneFun, runners, mw;
    doneFun = function(){
      return 'done :)';
    };
    runners = {};
    mw = {};
    return describe('create', function(){
      context('runner', function(){
        before(function(){
          runners.base = new BaseRunner;
          ctx = {
            runner: runners.base
          };
          return mw.base = new BaseMw(ctx);
        });
        describe('instance', function(){
          return specify('is a BaseMw', function(){
            return mw.base.constructor.should.be.eql(BaseMw);
          });
        });
        describe('context', function(){
          return specify('should be set', function(){
            return mw.base.context.should.be.eql(ctx);
          });
        });
        describe('name', function(){
          return specify('should be set', function(){
            return mw.base.name.should.be.eql('base-mw');
          });
        });
        return describe('runner', function(){
          return specify('should be set', function(){
            return mw.base.runner.should.be.eql(runners.base);
          });
        });
      });
      describe('error', function(){
        context('Mw-component run method causes error', function(){
          before(function(){
            mw.base = new BaseMw;
            runners.base.clean();
            runners.base.use(mw.base);
            mw.base.run = function(){
              return this.error('very bad stuff!');
            };
            return runners.base.run();
          });
          return specify('adds to runner errors', function(){
            return runners.base.errors['base-mw'].should.eql(['very bad stuff!']);
          });
        });
        return context('Mw-component run method causes two errors!', function(){
          var errors;
          errors = {
            a: 'very bad stuff!',
            b: 'more baaaad'
          };
          before(function(){
            mw.base = new BaseMw;
            runners.base.clean();
            runners.base.use(mw.base);
            mw.base.run = function(){
              this.error(errors.a);
              return this.error(errors.b);
            };
            return runners.base.run();
          });
          return specify('adds to runner errors', function(){
            return runners.base.errors['base-mw'].should.eql([errors.a, errors.b]);
          });
        });
      });
      return describe('abort', function(){
        return context('Mw-component run method causes error', function(){
          before(function(){
            mw.base = new BaseMw;
            mw.next = new BaseMw({
              name: 'next'
            });
            runners.base.clean();
            runners.base.use(mw.base).use(mw.next);
            mw.base.run = function(){
              return this.abort();
            };
            return runners.base.run();
          });
          describe('mw-component', function(){
            specify('aborted is true', function(){
              return mw.base.aborted().should.be['true'];
            });
            specify('has-errors is false', function(){
              return mw.base.hasErrors().should.be['false'];
            });
            specify('is-success is false', function(){
              return mw.base.isSuccess().should.be['false'];
            });
            return specify('is-failure is true', function(){
              return mw.base.isFailure().should.be['true'];
            });
          });
          return describe('runner', function(){
            specify('aborted is true', function(){
              return runners.base.aborted.should.be['true'];
            });
            specify('aborted-by is BaseMw', function(){
              return runners.base.abortedBy.should.eql('base-mw');
            });
            specify('index is still 0', function(){
              return runners.base.index.should.eql(0);
            });
            return specify('current-middleware is middleware which aborted: BaseMw', function(){
              return runners.base.currentMiddleware().name.should.eql('base-mw');
            });
          });
        });
      });
    });
  });
}).call(this);
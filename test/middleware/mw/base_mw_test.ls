require! '../../test_setup'
BaseMw = require '../../../mw/base_mw'

describe 'base middleware' ->
  var mw

  before ->
    mw := new BaseMw 'hello'

  specify 'should be a BaseMw' ->
    mw.constructor.should.be.eql BaseMw

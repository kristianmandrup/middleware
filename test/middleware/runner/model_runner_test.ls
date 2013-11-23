require! '../../test_setup'
ModelRunner = require '../../../runner/model_runner'

class User
  (@name) ->

  name: 'unknown'

describe 'model runner' ->
  var runner, user

  before ->
    user    := new User 'kris'
    runner  := new ModelRunner model: 'user', data: user

  specify 'should be a ModelRunner' ->
    runner.constructor.should.be.eql ModelRunner

  specify 'should have name model' ->
    runner.name.should.be.eql 'model'

  specify 'should have the model user' ->
    runner.model.should.be.eql 'user'

  specify 'should have the data model user' ->
    runner.data.should.be.eql user

  specify 'should have the model name of user' ->
    runner.data.name.should.be.eql user.name
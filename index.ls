module.exports =
  mw:
    base:   require './mw/base_mw'
    simple: require './mw/simple_mw'
  runner:
    base:   require './runner/base_runner'
    model:  require './runner/model_runner'
  config:
    model:  require './config/model_config'
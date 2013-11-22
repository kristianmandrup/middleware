# TODO: move to model-mw project

authorization = require 'authorization'
validation = require 'validation'

Middleware('model').on(before: 'mutate')
  .use(authorization)
  .use(validation)
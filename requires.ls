require 'sugar'

_   = require 'prelude-ls'

underscore = (...items) ->
  items = items.flatten!
  strings = items.map (item) ->
    String(item)
  _.map (.underscore!), strings

full-path = (base, ...paths) ->
  upaths = underscore(...paths)
  ['.', base, upaths].flatten!.join '/'

test-path = (...paths) ->
  full-path 'test', ...paths

mw-path = (...paths) ->
  full-path 'mw', ...paths

runner-path = (...paths) ->
  full-path 'runner', ...paths

module.exports =
  test: (...paths) ->
    require test-path(...paths)

  mv: (...paths) ->
    require mv-path(...paths)

  runner: (...paths) ->
    require runner-path(...paths)

  fixture: (path) ->
    @test 'fixtures', path

  # alias
  fix: (path) ->
    @fixture path

  factory: (path) ->
    @test 'factories', path

  # alias
  fac: (path) ->
    @factory path

  file: (path) ->
    p = full-path('.', path)
    # console.log 'requires.file', p
    require p

  # m - alias for module
  m: (path) ->
    @file path

  files: (...paths) ->
    paths.flatten!.map (path) ->
      @file path

  fixtures: (...paths) ->
    paths.flatten!.map (path) ->
      @fixture path

  tests: (...paths) ->
    paths.flatten!.map (path) ->
      @test path

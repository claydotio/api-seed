log = require 'loglevel'
nock = require 'nock'

config = require 'config'

before ->
  nock.enableNetConnect('0.0.0.0')

  unless config.VERBOSE
    log.disableAll()

  # Reset databases

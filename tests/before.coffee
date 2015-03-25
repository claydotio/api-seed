log = require 'loglevel'

config = require 'config'

before ->
  unless config.DEBUG
    log.disableAll()

  # Reset databases

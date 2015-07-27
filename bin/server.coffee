#!/usr/bin/env coffee
log = require 'loga'

server = require '../'
config = require '../config'

server.setup().then ->
  server.listen config.PORT, ->
    log.info 'Listening on port %d', config.PORT

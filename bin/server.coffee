#!/usr/bin/env coffee
log = require 'loga'

{setup, app} = require '../'
config = require '../config'

setup().then ->
  app.listen config.PORT, ->
    log.info 'Listening on port %d', config.PORT

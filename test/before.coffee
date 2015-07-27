log = require 'loga'
nock = require 'nock'

config = require 'config'
server = require 'index'

DB = config.RETHINK.DB
HOST = config.RETHINK.HOST

r = require('rethinkdbdash')
  host: HOST
  db: DB

before ->
  nock.enableNetConnect('0.0.0.0')

  unless config.VERBOSE
    log.level = null

  r.dbList()
  .contains DB
  .do (result) ->
    r.branch result,
      r.dbDrop(DB),
      {dopped: 0}
  .run()
  .then server.setup

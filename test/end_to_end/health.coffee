server = require '../../index'
flare = require('flare-gun').express(server.app)

describe 'Health Check Routes', ->
  describe 'GET /healthcheck', ->
    it 'returns healthy', ->
      flare
        .get '/healthcheck'
        .expect 200,
          rethinkdb: true
          healthy: true

  describe 'GET /ping', ->
    it 'pongs', ->
      flare
        .get '/ping'
        .expect 200, 'pong'

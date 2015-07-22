_ = require 'lodash'
server = require '../../index'
flare = require('flare-gun').express(server.app)

schemas = require '../../schemas'

describe 'User Routes', ->
  describe 'POST /users', ->
    it 'returns new user', ->
      flare
        .post '/users', {username: 'test'}
        .expect 200, schemas.user

    describe '400', ->
      it 'fails with invalid username', ->
        flare
          .post '/users', {username: 123}
          .expect 400

  describe 'GET /users/:id', ->
    it 'returns user', ->
      flare
        .post '/users', {username: 'test'}
        .stash 'me'
        .get '/users/:me.id'
        .expect 200, ':me'

    describe '400', ->
      it 'returns 404 if user not found', ->
        flare
          .get '/users/-1'
          .expect 404

  describe 'PUT /users/:id', ->
    it 'updates user', ->
      flare
        .post '/users', {username: 'test'}
        .expect 200
        .stash 'me'
        .put '/users/:me.id', {username: 'changed'}
        .expect 200, _.defaults {
          username: 'changed'
        }, schemas.user
        .get '/users/:me.id'
        .expect 200, _.defaults {
          username: 'changed'
        }, schemas.user

    describe '400', ->
      it 'fails if invalid update values', ->
        flare
          .post '/users', {username: 'test'}
          .stash 'me'
          .put '/users/:me.id', {username: 123}
          .expect 400

      it 'returns 404 if user not found', ->
        flare
          .put '/users/-1'
          .expect 404

  describe 'DELETE /users/:id', ->
    it 'removes user', ->
      flare
        .post '/users', {username: 'test'}
        .expect 200
        .stash 'me'
        .del '/users/:me.id'
        .expect 204
        .get '/users/:me.id'
        .expect 404

    describe '400', ->
      it 'returns 404 if user not found', ->
        flare
          .del '/users/-1'
          .expect 404

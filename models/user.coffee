_ = require 'lodash'
Promise = require 'bluebird'
uuid = require 'node-uuid'

r = require '../services/rethinkdb'
config = require '../config'

USERS_TABLE = 'users'

defaultUser = (user) ->
  _.assign {
    id: uuid.v4()
    username: null
  }, user

class UserModel
  RETHINK_TABLES: [
    {
      NAME: USERS_TABLE
      INDEXES: [
        {
          name: 'username'
        }
      ]
    }
  ]

  create: (user) ->
    user = defaultUser user

    r.table USERS_TABLE
    .insert user
    .run()
    .then ->
      user

  getById: (id) ->
    r.table USERS_TABLE
    .get id
    .run()
    .then defaultUser

  updateById: (id, diff) ->
    r.table USERS_TABLE
    .get id
    .update diff
    .run()

  deleteById: (id) ->
    r.table USERS_TABLE
    .get id
    .delete()
    .run()

  sanitize: _.curry (requesterId, user) ->
    _.pick user, [
      'id'
      'username'
    ]

module.exports = new UserModel()

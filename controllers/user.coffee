_ = require 'lodash'
Joi = require 'joi'
router = require 'promise-router'

User = require '../models/user'
schemas = require '../schemas'

class UserCtrl
  create: (req) ->
    username = req.body?.username

    valid = Joi.validate {username}, {
      username: schemas.user.username
    }, {presence: 'required'}

    if valid.error
      throw new router.Error status: 400, detail: valid.error.message

    User.create {username}
    .then User.sanitize(null)

  getById: (req) ->
    id = req.params.id

    User.getById id
    .tap (user) ->
      unless user
        throw new router.Error status: 404, detail: 'user not found'
    .then User.sanitize(null)

  updateById: (req) ->
    id = req.params.id
    diff = req.body

    updateSchema =
      username: schemas.user.username

    diff = _.pick diff, _.keys(updateSchema)
    updateValid = Joi.validate diff, updateSchema

    if updateValid.error
      throw new router.Error status: 400, detail: updateValid.error.message

    User.updateById id, diff
    .then ({replaced}) ->
      if replaced is 0
        throw new router.Error status: 404, detail: 'user not found'
      User.getById id
    .then User.sanitize(null)

  deleteById: (req) ->
    id = req.params.id

    User.deleteById(id)
    .then ({deleted}) ->
      if deleted is 0
        throw new router.Error status: 404, detail: 'user not found'
    .then ->
      null


module.exports = new UserCtrl()

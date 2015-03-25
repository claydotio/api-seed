Joi = require 'joi'

router = require 'promise-router'

class ExamplePolicy
  assertExists: (shouldExist) ->
    unless shouldExist
      throw new router.Error404 'User not found'

module.exports = new ExamplePolicy()

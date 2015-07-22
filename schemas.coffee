Joi = require 'joi'

id =  Joi.string().regex(
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/ # uuid
)

user =
  id: id
  username: Joi.string()

module.exports = {
  id: id
  user
}

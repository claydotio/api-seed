router = require 'promise-router'
HealthCtrl = require './controllers/health'
UserCtrl = require './controllers/user'

###################
# Public Routes   #
###################

router.route 'get', '/healthcheck',
  HealthCtrl.check

router.route 'get', '/ping',
  HealthCtrl.ping

router.route 'post', '/users',
  UserCtrl.create

router.route 'get', '/users/:id',
  UserCtrl.getById

router.route 'put', '/users/:id',
  UserCtrl.updateById

router.route 'delete', '/users/:id',
  UserCtrl.deleteById

module.exports = router.getExpressRouter()

_ = require 'lodash'
log = require 'loglevel'

env = process.env

defaultsDeep = _.partialRight _.merge, deep = (value, other) ->
  _.merge value, other, deep

getDeepUndefinedKeys = (object, prefix = '') ->
  _.reduce object, (missing, val, key) ->
    unless val?
      return missing.concat prefix + key
    if _.isPlainObject val
      return missing.concat getDeepUndefinedKeys val, key + '.'
    return missing
  , []

defaults =
  DEBUG: true
  ENVS:
    DEV: 'development'
    PROD: 'production'
    TEST: 'test'
  PORT: 50010

config = defaultsDeep
  DEBUG: if env.DEBUG then env.DEBUG is '1' else undefined
  ENV: env.NODE_ENV
  PORT: env.API_PORT or env.PORT
, defaults

missingConfig = getDeepUndefinedKeys config
unless _.isEmpty missingConfig
  log.warn 'Config missing values for:', '\n  ' + missingConfig.join '\n  '

module.exports = config

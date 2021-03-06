cors = require 'cors'
express = require 'express'
bodyParser = require 'body-parser'
fs = require 'fs'
Promise = require 'bluebird'
_ = require 'lodash'

config = require './config'
routes = require './routes'
r = require './services/rethinkdb'

# Setup rethinkdb
createDatabaseIfNotExist = (dbName) ->
  r.dbList()
  .contains dbName
  .do (result) ->
    r.branch result,
      {created: 0},
      r.dbCreate dbName
  .run()

createTableIfNotExist = (tableName, options) ->
  r.tableList()
  .contains tableName
  .do (result) ->
    r.branch result,
      {created: 0},
      r.tableCreate tableName, options
  .run()

createIndexIfNotExist = (tableName, indexName, indexFn, indexOpts) ->
  r.table tableName
  .indexList()
  .contains indexName
  .run() # can't use r.branch() with r.row() compound indexes
  .then (isCreated) ->
    unless isCreated
      (if indexFn?
        r.table tableName
        .indexCreate indexName, indexFn, indexOpts
      else
        r.table tableName
        .indexCreate indexName, indexOpts
      ).run()

setup = ->
  createDatabaseIfNotExist config.RETHINK.DB
  .then ->
    Promise.map fs.readdirSync('./models'), (modelFile) ->
      model = require('./models/' + modelFile)
      tables = model?.RETHINK_TABLES or []

      Promise.map tables, (table) ->
        createTableIfNotExist table.name, table.options
        .then ->
          Promise.map (table.indexes or []), ({name, fn, options}) ->
            fn ?= null
            createIndexIfNotExist table.name, name, fn, options
        .then ->
          r.table(table.name).indexWait().run()

app = express()

app.set 'x-powered-by', false

app.use bodyParser.json()
app.use cors()
app.use routes

module.exports = {
  app
  setup
}

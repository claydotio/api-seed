gulp = require 'gulp'
mocha = require 'gulp-mocha'
shell = require 'gulp-shell'
nodemon = require 'gulp-nodemon'
istanbul = require 'gulp-coffee-istanbul'
coffeelint = require 'gulp-coffeelint'
clayLintConfig = require 'clay-coffeescript-style-guide'

paths =
  serverBin: './bin/server.coffee'
  tests: './tests/**/*.coffee'
  coffee: [
    './**/*.coffee'
    '!./node_modules/**/*'
  ]


gulp.task 'default', ['server']

gulp.task 'server', ->
  nodemon script: paths.serverBin, ext: 'coffee'

gulp.task 'watch', ->
  gulp.watch paths.coffee, ['watch-test']

gulp.task 'watch-test', shell.task [
  './bin/test.sh'
]

gulp.task 'test', (if process.env.LINT is '1' then ['lint'] else []), ->
  if process.env.COVERAGE is '1'
    gulp.src paths.coffee
    .pipe istanbul includeUntested: true
    .pipe istanbul.hookRequire()
    .on 'finish', ->
      gulp.src paths.tests
      .pipe mocha(timeout: 5000, useColors: true)
      .pipe istanbul.writeReports()
      .once 'end', -> process.exit()
  else
    gulp.src paths.tests
    .pipe mocha(timeout: 5000, useColors: true)
    .once 'end', -> process.exit()

gulp.task 'lint', ->
  gulp.src paths.coffee
    .pipe coffeelint(null, clayLintConfig)
    .pipe coffeelint.reporter()

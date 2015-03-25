gulp = require 'gulp'
mocha = require 'gulp-mocha'
shell = require 'gulp-shell'
nodemon = require 'gulp-nodemon'
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

gulp.task 'watch', ['server'], ->
  gulp.watch paths.coffee, ['watch-test']

gulp.task 'watch-test', shell.task [
  './bin/test.sh'
]

gulp.task 'test', (if process.env.LINT is '1' then ['lint'] else []), ->
  gulp.src paths.tests
  .pipe mocha(timeout: 5000)
  .once 'end', -> process.exit()

gulp.task 'lint', ->
  gulp.src paths.coffee
    .pipe coffeelint(null, clayLintConfig)
    .pipe coffeelint.reporter()

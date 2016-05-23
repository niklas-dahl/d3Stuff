gulp            =  require 'gulp'
runSequence     =  require 'run-sequence'
sourcemaps      =  require 'gulp-sourcemaps'
del             =  require 'del'
nodemon         =  require 'gulp-nodemon'

coffee          =  require 'gulp-coffee'
jade            =  require 'gulp-jade'
sass            =  require 'gulp-sass'

notifier        =  require 'node-notifier'

# front end source files
paths =
  index:  'client/*.jade'
  sass:   'client/**/*.scss'
  coffee: 'client/**/*.coffee'
  images: 'img/**'

# front end build files
distPaths =
  index: 'dist/index.html'
  css: 'dist/css/**/*.css'

gulp.task 'copyIndex', () ->
  gulp.src paths.index
    .pipe jade({ pretty: true }).on('error', notifyJadeError)
    .pipe gulp.dest 'dist'

gulp.task 'copySass', () ->
  gulp.src paths.sass
    .pipe sourcemaps.init()
    .pipe sass().on('error', notifySassError)
    .pipe sourcemaps.write()
    .pipe gulp.dest 'dist/css'

gulp.task 'copyCoffee', () ->
  gulp.src paths.coffee
    .pipe sourcemaps.init()
    .pipe coffee().on('error', notifyCoffeeError)
    .pipe sourcemaps.write()
    .pipe gulp.dest 'dist/js'

gulp.task 'copyImages', () ->
  gulp.src paths.images
    .pipe gulp.dest 'dist/img/'

gulp.task 'build', () ->
  runSequence 'copySass', 'copyIndex', 'copyCoffee', 'copyImages'

gulp.task 'default', () ->
  runSequence 'build', ['watch', 'nodemon']

gulp.task 'watch', () ->
  gulp.watch paths.sass, ['copySass']
  gulp.watch paths.index, ['copyIndex']
  gulp.watch paths.coffee, ['copyCoffee']
  gulp.watch paths.images, ['copyImages']

notifyCoffeeError = (err) ->
  this.emit('end')
  notifier.notify {
    title: "Coffee: #{err.message}"
    message: "#{err.name} Line: #{err.location.first_line} - #{err.location.last_line}" + '\n' + err.filename
  }

notifyJadeError = (err) ->
  this.emit('end')
  notifier.notify {
    title: "Jade: #{err.name}"
    message: "#{err.path}"
  }

notifySassError = (err) ->
  this.emit('end')
  notifier.notify {
    title: "Sass: #{err.name} Line: #{err.line}"
    message: "#{err.message}"
  }

notifyServerError = () ->
  notifier.notify {
    title: "Server app crashed"
    message: "waiting for file changes before restarting..."
  }

# nodemon development server
gulp.task 'nodemon', () ->
  nodemon({
    script: 'server.coffee'
    # ext: 'js html'
    watch: ['server.coffee']
    env: { 'NODE_ENV': 'development' }
  }).on 'crash', () ->
    notifyServerError()
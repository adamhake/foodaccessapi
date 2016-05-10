browserify  = require "browserify"
buffer      = require "vinyl-buffer"
coffeeify   = require "coffeeify"
gulp        = require "gulp"
gutil       = require "gulp-util"
rename      = require "gulp-rename"
source      = require "vinyl-source-stream"
sourcemaps  = require "gulp-sourcemaps"
sass        = require "gulp-sass"

# Complile Coffee Script
gulp.task "scripts", ->
  b = browserify
    entries: "./src/js/main.coffee"
    debug: true

  b.transform 'coffeeify'
  .bundle()
  .pipe source './src/js/app.js'
  .pipe buffer()
  .pipe sourcemaps.init
    loadMaps: true
  .on 'error', gutil.log
  .pipe sourcemaps.write './'
  .pipe rename
    dirname : "/js"
  .pipe gulp.dest "./dist/"

# Watch Coffee Script Changes
gulp.task "scripts:watch", ->
  gulp.watch "./src/js/**/*.coffee", ["scripts"]

# Compile Sass
gulp.task "sass", ->
  gulp.src "./src/scss/app.scss"
  .pipe sourcemaps.init()
  .pipe sass().on 'error', sass.logError
  .pipe sourcemaps.write()
  .pipe gulp.dest './dist/css'

# Watch for Sass file changes
gulp.task "sass:watch", ->
  gulp.watch "./src/scss/**/*.scss", ["sass"]

gulp.task "build", ["scripts", "sass"]

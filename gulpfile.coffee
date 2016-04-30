gulp    = require 'gulp'
sass    = require 'gulp-sass'
plumber = require 'gulp-plumber'

# Compile sass partials
#----------------------------
gulp.task 'sass', ->
  gulp.src("./src/scss/app.scss")
  .pipe plumber()
  .pipe sass()
  .pipe gulp.dest "./dist/css"

# Watch for sass file changes
#----------------------------
gulp.task "sass:watch", () ->
  gulp.watch "./src/scss/**/*.scss", ["sass"]

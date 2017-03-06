var browserify, coffee, coffeeify, gulp, less, livereload, path, source, util, watch, watchify;

gulp = require('gulp');

coffee = require('gulp-coffee');

util = require('gulp-util');

watch = require('gulp-watch');

livereload = require('gulp-livereload');

watchify = require('watchify');

browserify = require('browserify');

coffeeify = require('coffeeify');

source = require('vinyl-source-stream');

path = require('path');

gulp.task('coffee-watch', function() {
  var bundler, rebundle;
  bundler = watchify(browserify('./coffee/main.coffee', watchify.args));
  bundler.transform('coffeeify');
  rebundle = function() {
    util.log('Rebundling');
    return bundler.bundle().on('error', util.log.bind(util, 'Browserify error')).pipe(source('bundle.js')).pipe(gulp.dest('static/build')).pipe(livereload({
      auto: false
    }));
  };
  bundler.on('update', rebundle);
  return rebundle();
});

gulp.task('coffee', function() {
  return gulp.src('./coffee/*.coffee').pipe(coffee()).pipe(gulp.dest('static/build'));
});

gulp.task('default', ['coffee']);

gulp.task('server', function() {
  return livereload.listen();
});

gulp.task('watch', ['server', 'coffee-watch'], function() {
  return watch('*.html', function(files, cb) {
    livereload.changed();
    return cb();
  });
});

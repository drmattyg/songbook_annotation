gulp = require 'gulp'
webpack = require 'webpack-stream'
del = require 'del'
rename = require 'gulp-rename'
coffee = require 'gulp-coffee'
gutil = require 'gulp-util'
debug = require 'gulp-debug'
sourcemaps = require 'gulp-sourcemaps'
exec = require('child_process').exec;
cjsx = require 'gulp-cjsx'
sass = require 'gulp-sass'
newer = require 'gulp-newer'
named = require 'vinyl-named'
fs = require 'fs'
path = require 'path'
jest = require 'jest'
zip = require 'gulp-vinyl-zip'
shrinkwrap = require 'gulp-shrinkwrap'
modify = require 'gulp-modify'

# Directory for build output
DIST_DIR='dist'
BUILD_TMP='build_tmp'
LIB_CACHE='webpack_cache'
JUNIT_RESULTS='junitresults.xml'
CWD=process.cwd()

# global to put git metadata into
git_json = {}

# a newer() that can check either a .coffee or .cjsx
# against its compiled JavaScript output
newer_coffee = (target_dir)->
  compiled_name = (coffee_name)->
    return coffee_name.replace(/\.(?:coffee|cjsx)$/, '.js')
  return newer({dest: target_dir, map: compiled_name})

# compiles the webpack configs
gulp.task 'webpack-config', ->
  return gulp.src('build/*.coffee')
    .pipe(newer_coffee(BUILD_TMP))
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest(BUILD_TMP))

# packs up dependencies into the codepack bundle
gulp.task 'webpack-lib', ['webpack-config'], ->
  return gulp.src "#{BUILD_TMP}/webpack-lib-entry.js"
    .pipe(newer("#{DIST_DIR}/codepack.js"))
    .pipe(webpack(require("./#{BUILD_TMP}/webpack-lib.conf.js")))
    .pipe(gulp.dest(DIST_DIR))

# packs all the app code into the app bundle
gulp.task 'webpack-app', ['webpack-config', 'compile'], ->
  return gulp.src "#{BUILD_TMP}/webpack-app-entry.js"
    .pipe(webpack(require("./#{BUILD_TMP}/webpack-app.conf.js")))
    .pipe(gulp.dest(DIST_DIR))

# move worker javascript to the right place in the tree
# - they must be standalone files, not webpacked together
gulp.task 'workers', ['compile'], ->

  webpack_options =
    devtool: 'inline-source-maps'
    target: 'webworker'

  return gulp.src("#{BUILD_TMP}/app/worker/*Worker.js")
    .pipe(newer("#{DIST_DIR}/worker/"))
    .pipe(named())
    .pipe(webpack(webpack_options))
    .pipe(gulp.dest("#{DIST_DIR}/worker/"))

# copies the base css into the dist
#  - normalize.css
#  - skeleton framework
#  - fonts
gulp.task 'assets', ->
  gulp.src('index.html')
    .pipe(newer(DIST_DIR))
    .pipe(gulp.dest(DIST_DIR))

  # favicon
  gulp.src('assets/images/**')
    .pipe(newer("#{DIST_DIR}/images"))
    .pipe(gulp.dest("#{DIST_DIR}/images"))

  gulp.src('sass/*.sass')
    .pipe(newer({dest: "#{DIST_DIR}/css", ext: '.css'}))
    .pipe(sass())
    .pipe(gulp.dest("#{DIST_DIR}/css"))

  gulp.src('assets/js/**')
    .pipe(newer({dest: "#{DIST_DIR}/js", ext: '.js'}))
    .pipe(gulp.dest("#{DIST_DIR}/js"))

  return gulp.src('assets/css/**')
    .pipe(newer("#{DIST_DIR}/css"))
    .pipe(gulp.dest("#{DIST_DIR}/css"))

# builds all coffeescript from src/ into sourcemap javascript
# in build_tmp, to be bundled by webpack
gulp.task 'compile-coffee', ->
  return gulp.src('src/**/*.coffee')
    .pipe(newer_coffee("#{BUILD_TMP}/app"))
    .pipe(sourcemaps.init())
    .pipe(coffee())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest("#{BUILD_TMP}/app"))

gulp.task 'compile-cjsx', ->
  return gulp.src('src/*.cjsx')
    .pipe(newer({dest: "#{BUILD_TMP}/app", ext: ".js"}))
    .pipe(cjsx({bare: true}))
    .pipe(gulp.dest("#{BUILD_TMP}/app"))

gulp.task 'jest-tests', ['compile'], (task_done)->

  jest_callback = (result)->
    if result?
      gutil.log("Tests finished.")
    else
      gulp.error("Tests failed.")
    gutil.log(result)
    task_done()

  # arg to config mapping here
  # https://github.com/facebook/jest/blob/v14.1.0/packages/jest-config/src/setFromArgv.js
  jest_config =
    setupTestFrameworkScriptFile: "#{CWD}/test/jest-setup.js"
    verbose: false
    silent: true

  jest.runCLI(jest_config, __dirname, jest_callback)

  # return gulp.src("#{BUILD_TMP}")
  #   .pipe(jest(jest_config))


gulp.task 'deploy-lib', ->
  return gulp.src('src/lib/*js')
    .pipe(gulp.dest("#{BUILD_TMP}/app/lib/"))

gulp.task 'testserver', ['default'], (cb)->
  cmd = "coffee test/test_server.coffee dist"
  exec cmd, (error, stdout, stderr)->
    console.log stdout
    console.error stderr
    cb(error)

  return gulp.src("#{DIST_DIR}/**/*")
    .pipe(rename(renamer))
    .pipe(zip.zip(zipfile))
    .pipe(gulp.dest(OUTPUT))

gulp.task 'clean', ->
  del.sync([DIST_DIR, BUILD_TMP, JUNIT_RESULTS]) # synchronous delete

# builds all code into a testable form into build_tmp
gulp.task 'compile', ['compile-coffee', 'compile-cjsx', 'deploy-lib']

# constructs the full web tree
gulp.task 'dist', ['assets', 'webpack-lib', 'webpack-app', 'workers']

# runs unit tests
gulp.task 'test', ['compile', 'jest-tests']

# full default build
gulp.task 'default', ['clean', 'compile', 'test', 'dist']

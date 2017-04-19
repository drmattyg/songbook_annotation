_ = require 'lodash'
AnnotatorApp = require './annotator'

module.exports =
  main: =>
    console.log 'main entry point'
    $ ->
      config = {}
      AnnotatorApp config, $('#main').get(0)

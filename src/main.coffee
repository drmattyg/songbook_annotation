_ = require 'lodash'
AnnotatorApp = require './annotator'

module.exports =
  main: =>
    console.log 'main entry point'
    console.log 'wavesurfer: ', wavesurfer
    $ ->
      config = {}
      AnnotatorApp config, $('#main').get(0)

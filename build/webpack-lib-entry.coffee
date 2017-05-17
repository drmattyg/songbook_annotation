# set up the various libraries for the app
window.$ = require 'jquery'
window.jQuery = window.$
window._ = require 'lodash'
window.moment = require 'moment'
window.React = require 'react'
window.ReactDOM = require 'react-dom'
window.WaveSurfer = require 'wavesurfer'
# this plugin load attaches itself to WaveSurfer
require './app/lib/wavesurfer.timeline'
window.yaml = require 'js-yaml'

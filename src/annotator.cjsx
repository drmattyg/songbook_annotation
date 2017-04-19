_ = require 'lodash'
React = require 'react'
Player = require './player'
AnnotatorApp = React.createClass

  componentWillMount: ->

  render: ->
    <div className='annotator'>
      <Player/>
    </div>

  componentDidMount: ->
    console.log("App mounted.")

module.exports = (config, parentElement)->
          ReactDOM.render <AnnotatorApp />, parentElement

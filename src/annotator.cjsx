_ = require 'lodash'
React = require 'react'
Player = require './player'
Lyrics = require './lyrics'

AnnotatorApp = React.createClass
  componentWillMount: ->

  render: ->
    <div className='annotator'>
      <Player/>
      <div className='row'>
        <div className='six columns'>
          <div id='yaml-output'>
          YAML
          </div>
        </div>
        <div className='six columns'>
          <div id='lyrics-container' key='lyrics'>
            <Lyrics/>
          </div>
        </div>
      </div>
    </div>

  componentDidMount: ->
    console.log("App mounted.")

module.exports = (config, parentElement)->
          ReactDOM.render <AnnotatorApp />, parentElement

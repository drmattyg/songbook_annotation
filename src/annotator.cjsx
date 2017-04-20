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
            <Lyrics recordTap={@record_lyric_tap}/>
          </div>
        </div>
      </div>
    </div>

  componentDidMount: ->
    console.log("App mounted.")

  record_lyric_tap: (comment)=>
    console.log "lyric tap:", comment

module.exports = (config, parentElement)->
          ReactDOM.render <AnnotatorApp />, parentElement

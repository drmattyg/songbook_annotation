_ = require 'lodash'
React = require 'react'
Player = require './player'
Lyrics = require './lyrics'
Songbook = require './songbook'

AnnotatorApp = React.createClass
  componentWillMount: ->
    window.annotator_app = @

  render: ->
    <div className='annotator'>
      <Player ticks={@ticks} recordTap={@record_tap} key='player'/>
      <div className='row'>
        <div className='six columns'>
          <div id='yaml-output'>
            <div id='yaml-frame'>
              <Songbook ref={@songbook_ref} key='songbook'/>
            </div>
          </div>
        </div>
        <div className='six columns'>
          <div id='lyrics-container' key='lyrics'>
            <Lyrics recordTap={@record_tap}/>
          </div>
        </div>
      </div>
    </div>

  componentDidMount: ->
    console.log("App mounted.")
    @taps = []

  songbook_ref: (ref)->
    @songbook = ref

  record_tap: (comment)->
    if @last_tick?
      entry = _.cloneDeep(@last_tick)
      entry.comment = comment
      entry.raw = entry.raw * 1000
      @taps.push(entry)
      console.log "tap:", entry
      _state = _.cloneDeep(@state)
      if @songbook?
        console.log "writing songbook"
        @songbook.taps(_.cloneDeep(@taps))
      else
        console.warn "no songbook available!"

  ticks: (tick)->
    @last_tick = tick

module.exports = (config, parentElement)->
          ReactDOM.render <AnnotatorApp />, parentElement

_ = require 'lodash'

TimeCode = require "./timecode"

Player = React.createClass
  getInitialState: ->
    play_status: "paused"
    timecode: "00:00:00.0"

  render: ->
    <div className='row'>
      <div className='twelve columns'>
        <div id="player-container">
          <div id="wavesurfer" key="player_control" ref={@get_elem_ref}></div>
          <div id="timeline" key="timeline_control"></div>
        </div>
      </div>
      <div className='row'>
        <div id='playpause' className='four columns'>
            <button className='.u-full-width' onClick={@do_play_pause}>{if @state.play_status == "paused" then "Play" else "Pause"}</button>
        </div>
        <div id='tapandmark' className='four columns'>
            <button className='.u-full-width'>tap</button>
        </div>
        <div id='timecode' className='four columns'>
            <TimeCode timecode={@state.timecode}/>
        </div>
      </div>
    </div>

  get_elem_ref: (elem)->
    @player_elem = elem
    @init_wavesurfer()

  init_wavesurfer: ()->
    @wavesurfer = WaveSurfer.create
      container: @player_elem
    window.w = @wavesurfer

    @wavesurfer.load("/air.mp3")

    @wavesurfer.on "audioprocess", =>
      _state = @state
      _state.timecode = @wavesurfer.getCurrentTime()
      @setState _state

    @wavesurfer.on "pause", =>
      _state = @state
      _state.play_status = "puased"
      @setState _state

    @wavesurfer.on "play", =>
      _state  = @state
      _state.play_status = "playing"
      @setState _state

    @wavesurfer.on "ready", =>
      @timeline = Object.create(WaveSurfer.Timeline)
      @timeline.init
        wavesurfer: @wavesurfer
        container: '#timeline'
      @wavesurfer.play()

  do_play_pause: (e)->
    console.log "play/pause click", e
    @wavesurfer.playPause()

  one_last_thing: ->
    # the cjsx compiler gets weird

module.exports = Player

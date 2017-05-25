# CHANGE THE MUSIC HERE - (path relative to assets/ folder)
MUSIC = "/air.mp3"

_ = require 'lodash'
TimeCode = require "./timecode"

zero_pad = (number)->
  "0#{number}".slice(-2)

format_timecode = (timecode)->
    _timecode = moment.duration(timecode, "seconds")
    hours = zero_pad(_timecode.hours())
    minutes = zero_pad(_timecode.minutes())
    seconds = zero_pad(_timecode.seconds())
    fraction = "#{Math.floor(_timecode.milliseconds() / 100)}"
    _timecode_string = "#{hours}:#{minutes}:#{seconds}.#{fraction}"

Player = React.createClass
  getInitialState: ->
    state =
      play_status: "paused"
      timecode: "00:00:00.0"
    return state

  componentWillMount: ->
    @ticks = @props.ticks

  render: ->
    <div id='player'>
      <div className='row'>
        <div className='twelve columns'>
          <div id="player-container">
            <div id="wavesurfer" key="player_control" ref={@get_elem_ref}></div>
            <div id="timeline" key="timeline_control"></div>
          </div>
        </div>
        <div className='row'>
          <div id='playpause' className='four columns'>
              <button className='u-full-width' onClick={@do_play_pause}>{if @state.play_status == "paused" then "Play" else "Pause"}</button>
          </div>
          <div id='tapandmark' className='four columns'>
              <button className='u-full-width button-primary' onClick={@do_tap}>tap</button>
          </div>
          <div id='timecode' className='four columns'>
            <button id='timecode-container' className='u-full-width button-primary' onClick={@choose_song} title='Click to load song'>
              <TimeCode ref={@get_timecode_ref}/>
            </button>
          </div>
        </div>
      </div>
      <div id='uploader'><input type="file" accept="audio/*" ref={@get_upload_input_ref} onChange={@load_song}></input></div>
    </div>

  get_timecode_ref: (comp)->
    @timecode = comp

  get_elem_ref: (elem)->
    @player_elem = elem
    @init_wavesurfer()

  get_upload_input_ref: (elem)->
    @upload_input = elem


  init_wavesurfer: ()->
    @wavesurfer = WaveSurfer.create
      container: @player_elem
    window.w = @wavesurfer

    @wavesurfer.load(MUSIC)

    @wavesurfer.on "audioprocess", =>
      raw_timecode = @wavesurfer.getCurrentTime()
      display_timecode = format_timecode(raw_timecode)

      _state = @state
      _state.raw_timecode = raw_timecode
      _state.display_timecode = display_timecode
      @setState _state

      _state = @timecode.state
      _state.timecode = display_timecode
      @timecode.setState _state
      # siphon off timecode events
      if @ticks?
        @ticks
          raw: raw_timecode
          display: display_timecode

    @wavesurfer.on "pause", =>
      _state = @state
      _state.play_status = "paused"
      @setState _state
      if @ticks?
        @ticks(null)

    @wavesurfer.on "play", =>
      _state  = @state
      _state.play_status = "playing"
      @setState _state

    @wavesurfer.on "ready", =>
      @timeline = Object.create(WaveSurfer.Timeline)
      @timeline.init
        wavesurfer: @wavesurfer
        container: '#timeline'
      # @wavesurfer.play()

  do_play_pause: (e)->
    @wavesurfer.playPause()

  do_tap: ->
    console.log "tap at timecode: #{@state.display_timecode} / #{@state.raw_timecode}"
    @props.recordTap "waveform player tap (changeme)"

  choose_song: ->
    $(@upload_input).click()

  load_song: (event)->
    @wavesurfer.pause()
    for upload in @upload_input.files
      @wavesurfer.empty()
      @wavesurfer.loadBlob(upload)
      $("#title h3").html(upload.name)
      window.songbook_title = upload.name



module.exports = Player

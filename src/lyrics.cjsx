Lyrics = React.createClass

  componentWillMount: ->
    @raw_lyrics = null

  getInitialState: ->
    _state =
      pastable: true
      lyrics: ''

  render: ->
    <div id='lyrics'>
      {if @state.pastable then @get_text_area() else @get_click_field()}
      <div>
        <button className='button button-primary u-full-width' onClick={@toggle_lyrics}>
          {if @state.pastable then "tap mode" else "edit lyrics"}
        </button>
      </div>
    </div>

  toggle_lyrics: (e)->
    # contruct new state
    _state = _.clone(@state)
    _state.pastable = not _state.pastable


    console.log 'text_area.value = ',@text_area?.value
    # update lyrics state if we were in editing mode
    if @state.pastable
      @raw_lyrics = @text_area.value
      console.log "recorded raw lyrics", @raw_lyrics

    # fire state change
    @setState _state

  update_lyrics: (pastable)->
    if pastable
      @text_area.value = @raw_lyrics
    else
      @raw_lyrics = @text_area.value

  get_text_area: ->
    _lyrics = if @raw_lyrics? then @raw_lyrics else ''
    <textarea placeholder='Paste lyrics here...' ref={@get_text_area_ref} defaultValue={_lyrics}></textarea>

  get_click_field: ->
    <div id="click-field">{@build_spans()}</div>

  build_spans: ->
    if @raw_lyrics?
      lines = @raw_lyrics.split("\n")
      spanned_lines = for line in lines
        do (line)->
          ("<span>#{word}</span>" for word in line.split(/\s+/)).join(" ")

      console.log spanned_lines
      full_spans =
        __html: ("<span class='lyric-line'>#{line}</span><br/>" for line in spanned_lines).join("\n")
      return <div dangerouslySetInnerHTML={full_spans}></div>
    else
      ''

  get_text_area_ref: (text_area)->
    @text_area = text_area
    console.log "Got text_area", @text_area

module.exports = Lyrics

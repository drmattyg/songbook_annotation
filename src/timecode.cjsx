

TimeCode = React.createClass
  getInitialState: ->
      state =
        timecode: @props.timecode ? "--:--:--.--"
        play_status: "paused"
      return state

  render: ->
    <span id='timecode-display'>{@state.timecode}</span>


module.exports = TimeCode

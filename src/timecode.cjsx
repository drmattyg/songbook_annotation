TimeCode = React.createClass
  getInitialState: ->
      timecode: @props.timecode
      play_status: "paused"

  render: ->
    <span className='timecode'>{@state.timecode}</span>


module.exports = TimeCode

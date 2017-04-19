_ = require 'lodash'

Player = React.createClass
  render: =>
    <div id="wavesurfer" ref={@get_elem_ref}></div>

  componentDidMount: ->
    console.log wavesurfer

  get_elem_ref: (elem)=>
    console.log "Got element:", elem
    @player_elem = elem
    wavesurfer.create
      constainer: @player_elem


module.exports = Player

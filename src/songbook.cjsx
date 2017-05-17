Songbook = React.createClass

  getInitialState: ->
    state =
      yamlbook: "# waiting for taps"
    return state

  render: ->
    <div className="yaml"><pre>{@state.yamlbook}</pre></div>

  taps: (taps)->
    sorted_taps = _.sortBy(taps, ['raw'])
    _yaml = yaml.safeDump(sorted_taps)
    console.log "YAML:\n#{_yaml}"
    @setState
      yamlbook: _yaml

module.exports = Songbook

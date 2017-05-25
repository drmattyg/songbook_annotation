
move_template =
  start_at: 0
  time: 100
  edges: [{
    edge: 0
    flame: 0
    dir: 1
  }]

header =
  version: 1.0
  songbook: [_.cloneDeep(move_template)]
  author: "my name here"
  title: "title"

Songbook = React.createClass

  getInitialState: ->
    state =
      yamlbook: "# waiting for taps"
    return state

  render: ->
    <div className="yaml"><pre>{@state.yamlbook}</pre></div>

  taps: (taps)->
    sorted_taps = _.sortBy(taps, ['raw'])
    moves = for move in sorted_taps

      songbook_entry = _.cloneDeep(move_template)
      songbook_entry.start_at = move.raw
      songbook_entry.comment = "(#{move.display}) #{move.comment}"
      songbook_entry

    songbook = _.cloneDeep(header)
    songbook.title = window.songbook_title ? "unknown song"
    songbook.songbook = moves
    console.log(songbook)
    _yaml = yaml.safeDump(songbook)
    console.log "YAML:\n#{_yaml}"
    @setState
      yamlbook: _yaml

module.exports = Songbook

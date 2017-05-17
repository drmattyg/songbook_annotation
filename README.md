# Songbook Annotator

A quick-and-dirty tool to get timecodes out of songs

## Setup

### install nodejs

That topic is adequately covered elsewhere

### install gulp
```
npm install -g gulp
```

### install all the node dependencies
```
npm install
```

## Using the annotator

### run the dev server
```
gulp serve
```

Load up http://localhost:3000/ in your browser.

Note that you will have to re-run gulp to pick up changes to the code.

### shutdown the dev server

Hit `Ctrl-c` in the shell where `gulp serve` was running.

## Changing the music

1. Place mp3 in the `assets/` folder
2. edit `src/player.cjsx`

You'll see this at the top of the file:
```
# CHANGE THE MUSIC HERE - (path relative to assets/ folder)
MUSIC = "/air.mp3"
```

Change the value of `MUSIC` to be an absolute path (starts with `/`) relative to the `assets/` folder.

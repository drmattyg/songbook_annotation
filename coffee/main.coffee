app = angular.module 'TAApp',['ngSanitize']
  #'btford.socket-io'
#]
# factory 'socket', (socketFactory) ->
#   return socketFactory()

app.controller "MainController", ($scope) -> 
  $scope.lyrics = ""
  $scope.output = ""
  $scope.taChange = () ->
    $scope.words = $scope.lyrics.split(" ");
    # tags = words.map((w, ix) -> 
    #   "<span ng-id='lyric_word_" + ix + "'>" + w + "</span>")
    # $scope.output = tags.join(" ")
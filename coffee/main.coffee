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
  $scope.wordClick = (ix) ->
    angular.element($("#lyrics_word_" + ix)).addClass("word_selected")

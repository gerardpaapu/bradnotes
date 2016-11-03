/*global Elm */
var app = Elm.Main.fullscreen();
app.ports.saveModel.subscribe(function (data) {
  console.log(data);
});

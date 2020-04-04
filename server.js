var express = require('express'); 
var app = express();
var http = require('http').Server(app);

// ------------------------------------
// Express
// ------------------------------------

app.use(express.static("./build/js/"));

// ------------------------------------
// HTTP
// ------------------------------------

var port = 8080;
http.listen(port, function(){
  console.log('listening on port ' + port);
}).on('error', (e) => {
  console.error('could not launch server', e);
});
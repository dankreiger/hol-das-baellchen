#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m' # No Color
cat > .gitignore << EOF
.gitignore
.DS_Store
node_modules
*.log
public/js/main.js
EOF
FILL_IN=$(printf "\n\n \xF0\x9F\x90\xB6 ${GREEN}Fill in app info (or just press enter for each line):${NC}")
echo $FILL_IN
npm init
npmglobals=('browserify' 'json')
npmmodules=('react' 'react-dom' 'babelify' 'watchify' 'babel-preset-react')
for i in "${npmglobals[@]}";do npm install -g $i; done
for j in "${npmmodules[@]}";do npm install --save $j; done
npm install whatwg-fetch --save
npm install body-parser
npm install express

json -I -f package.json -e 'this.scripts={
    "start": "watchify src/main.jsx -v -t [babelify --presets [ react ] ] -o public/js/main.js"
  }'

touch ./public/js/main.js
touch ./server.js


cat > server.js << EOF
var express = require('express');
var bodyParser = require('body-parser');
var app = express();

//Allow all requests from all domains & localhost
app.all('/*', function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "X-Requested-With, Content-Type, Accept");
  res.header("Access-Control-Allow-Methods", "POST, GET");
  next();
});

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));


var pups;

pups = [{
	id: 1,
	text: "wauwau"
}, {
	id: 2,
	text: "wag"
}, {
	id: 3,
	text: "bark"
}, {
	id: 4,
	text: "waggle"
}, {
	id: 5,
	text: "platz"
}, {
	id: 6,
	text: "awwww yes you are"
}, {
	id: 7,
	text: "flop those ears"
}];


app.get('/pups', function(req, res) {
    console.log("GET From SERVER");
    res.send(pups);
});

app.post('/pups', function(req, res) {
    var pup = req.body;
    console.log(req.body);
    pups.push(pup);
    res.status(200).send("Successfully posted pup");
});

app.listen(6060);
EOF


pwd=`pwd`
declare -a commands=("npm start" "pwd;node server.js" "pwd;sleep 7s;open public/index.html")

for i in "${commands[@]}"
do
  osascript -e "tell application \"Terminal\"" -e "tell application \"System Events\" to keystroke \"t\" using {command down}" -e "do script \"cd $pwd; $i\" in front window" -e "end tell" > /dev/null
done

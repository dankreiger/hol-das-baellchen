#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m' # No Color
cat > .gitignore << EOF
.gitignore
.DS_Store
node_modules
*.log
EOF
FILL_IN=$(printf "\n\n \xF0\x9F\x90\xB6 ${GREEN}Fill in app info (or just press enter for each line):${NC}")
echo $FILL_IN
npm init
npmglobals=('browserify' 'json')
npmmodules=('react' 'react-dom' 'babelify' 'watchify' 'babel-preset-react')
for i in "${npmglobals[@]}";do npm install -g $i; done
for j in "${npmmodules[@]}";do npm install --save $j; done
npm install whatwg-fetch --save

json -I -f package.json -e 'this.scripts={
    "start": "watchify src/main.jsx -v -t [babelify --presets [ react ] ] -o public/js/main.js"
  }'

touch public/js/main.js

pwd=`pwd`
declare -a commands=("npm start" "pwd;open public/index.html")

for i in "${commands[@]}"
do
  osascript -e "tell application \"Terminal\"" -e "tell application \"System Events\" to keystroke \"t\" using {command down}" -e "do script \"cd $pwd; $i\" in front window" -e "end tell" > /dev/null
done

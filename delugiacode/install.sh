#!/bin/sh

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

cd $HOME

info 'Begin delugiacode'

COMMANDS="curl"
 
# Read the array values with space
for COMMAND in $COMMANDS; do
  if [ ! $(command -v $COMMAND) ]; then
    fail "Could not find '$COMMAND' command. Is it installed?"
  else
    info "Found command $COMMAND: $(command -v $COMMAND)"
  fi
done

unset COMMANDS

info 'Getting latest release'

FONTS="Delugia.Nerd.Font.Complete"

for f in $FONTS; do
    URL="https://github.com/adam7/delugia-code/releases/latest/download/"
    URL="${URL}${f}.ttf"
    OUT="$f.ttf"
    info "Downloading $URL to $OUT"
    curl -L $URL --output $OUT
done

unset PAGE BASEURL PATTERN URL

if [ ! -d /usr/local/share/fonts/truetype/delugia-code ]; then
  info 'Creating directory: /usr/local/share/fonts/delugia-code'
  sudo mkdir -pv /usr/local/share/fonts/delugia-code
fi

info 'Installing fonts to /usr/share/local/fonts'

for f in $FONTS; do
  sudo cp $f.ttf /usr/local/share/fonts/delugia-code && rm $f.ttf
done

info 'Setting /usr/local/share/fonts/truetype/delugia-code to be world readable'
sudo chmod -R o+rX /usr/local/share/fonts

success 'Finish delugiacode'

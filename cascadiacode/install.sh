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

BASEURL="https://github.com"

info 'Getting latest release'
PAGE=$(curl --silent -L https://github.com/microsoft/cascadia-code/releases/latest)

if [ ! "$PAGE" ]; then
    fail 'Could not connect to GitHub'
fi

FONTS="Cascadia CascadiaMono CascadiaPL CascadiaMonoPL"

for f in $FONTS; do
    PATTERN="\/microsoft\/cascadia-code\/releases\/download\/v\d+\.\d+\/${f}\.ttf"
    URL=$(echo $PAGE | grep -oP "$PATTERN")
    URL="https://github.com${URL}"
    OUT="$f.ttf"
    info "Downloading $URL to $OUT"
    curl -L $URL --output $OUT
done

unset FONTS PAGE BASEURL PATTERN URL

# copy fonts to /usr/share/fonts/truetype/cascadia-code/*



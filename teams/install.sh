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
info 'Begin Teams'

COMMANDS="wget"
 
# Read the array values with space
for COMMAND in $COMMANDS; do
  if [ ! $(command -v $COMMAND) ]; then
    fail "Could not find '$COMMAND' command. Is it installed?"
  else
    info "Found command $COMMAND: $(command -v $COMMAND)"
  fi
done

cd $HOME

info 'Downloading...'
wget https://teams.microsoft.com/downloads/desktopurl?env=production\&plat=linux\&arch=x64\&download=true\&linuxArchiveType=deb -O TeamsLinux.deb

export DEBIAN_FRONTEND=noninteractive

info 'Installing Teams for Linux'
sudo dpkg -i ./TeamsLinux.deb && rm ./TeamsLinux.deb

success 'Finish Teams'

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

cd "$(dirname "$0")/.."
ROOT=$(pwd -P)
i3CONFIG=$HOME/.config/regolith/i3

if [ ! -d $i3CONFIG ]; then
    info 'Making i3 config directory'
    mkdir -p $i3CONFIG
fi

if [ -f $i3CONFIG/config ]; then
    info 'Removing extisting i3 config'
    rm $i3CONFIG/config
fi

info 'Creating symlink'
ln -s $ROOT/regolith/.config/i3/config $i3CONFIG/config

success 'Done!'
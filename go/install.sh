#!/bin/sh

# Install Go via mise

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

info 'Installing Go via mise'

MISE="${HOME}/.local/bin/mise"
if command -v mise > /dev/null 2>&1; then
  MISE="mise"
fi

$MISE use -g go@latest

success 'Go installed'

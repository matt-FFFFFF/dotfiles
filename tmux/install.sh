#!/bin/sh

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

info 'Installing tmux'

if [ "$(uname)" = "Darwin" ]; then
  success 'tmux managed via homebrew/Brewfile'
  exit 0
fi

if command -v dnf > /dev/null 2>&1; then
  sudo dnf install -y tmux
  success 'tmux installed via dnf'
  exit 0
fi

if command -v apt-get > /dev/null 2>&1; then
  sudo apt-get install -y tmux
  success 'tmux installed via apt'
  exit 0
fi

fail 'No supported package manager found (dnf, apt, brew)'

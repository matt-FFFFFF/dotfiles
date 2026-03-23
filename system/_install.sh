#!/bin/sh

# Install useful base tools before main installers run

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

info 'Installing base tools'

if [ "$(uname)" = "Darwin" ]; then
  brew install jq curl wget vim
  success 'Base tools installed via Homebrew'
  exit 0
fi

if command -v dnf > /dev/null 2>&1; then
  sudo dnf install -y jq curl wget vim zsh zsh-syntax-highlighting zsh-autosuggestions
  success 'Base tools installed via dnf'
  exit 0
fi

if command -v apt-get > /dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get install -y jq curl wget ack build-essential vim zsh
  success 'Base tools installed via apt'
  exit 0
fi

fail 'No supported package manager found (dnf, apt, brew)'

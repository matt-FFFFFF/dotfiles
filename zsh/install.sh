#!/bin/sh

# Install zsh and plugins

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

if [ "$(uname)" = "Darwin" ]; then
  brew install zsh-syntax-highlighting zsh-completions zsh-autosuggestions
  chmod -R go-w '/opt/homebrew/share'
  success 'zsh plugins installed via Homebrew'
  exit 0
fi

if command -v dnf > /dev/null 2>&1; then
  sudo dnf install -y zsh zsh-syntax-highlighting zsh-autosuggestions
  success 'zsh installed via dnf'
  exit 0
fi

if command -v apt-get > /dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get install -y zsh zsh-syntax-highlighting zsh-autosuggestions
  success 'zsh installed via apt'
  exit 0
fi

fail 'No supported package manager found (dnf, apt, brew)'

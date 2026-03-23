#!/bin/sh

# Install mise and all tools defined in config.toml

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

# Install mise if not present
if ! command -v mise > /dev/null 2>&1 && [ ! -x "$HOME/.local/bin/mise" ]; then
  info 'Installing mise'
  if [ "$(uname)" = "Darwin" ]; then
    brew install mise
  else
    curl https://mise.run | sh
  fi
  success 'mise installed'
else
  info 'mise already installed, skipping'
fi

MISE="${HOME}/.local/bin/mise"
if command -v mise > /dev/null 2>&1; then
  MISE="mise"
fi

# Install all tools from config.toml
info 'Installing mise tools'
$MISE install

success 'mise tools installed'

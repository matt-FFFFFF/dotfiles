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
  sudo dnf install -y \
    jq curl wget vim \
    zsh zsh-syntax-highlighting zsh-autosuggestions \
    tmux ripgrep \
    fuse fuse-libs \
    python3-pip \
    libicu libsecret xdg-utils
  success 'Base tools installed via dnf'

  if [ -n "$TOOLBOX_PATH" ]; then
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    TOOLBOX_SCRIPT="$SCRIPT_DIR/../fedora/toolbox.sh"
    if [ -f "$TOOLBOX_SCRIPT" ]; then
      info 'Detected Fedora toolbox — running toolbox setup'
      bash "$TOOLBOX_SCRIPT"
    fi
  fi

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

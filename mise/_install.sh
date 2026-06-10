#!/bin/sh

# Install mise and all tools defined in config/config.toml.
# Named _install.sh so script/install runs it before every other installer —
# most topics now get their tools from mise rather than a package manager.

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

# Make sure the global config is the symlinked dotfiles one (script/bootstrap
# normally does this, but `mise install` needs it if run standalone)
if [ ! -e "$HOME/.config/mise" ]; then
  info 'Linking mise config'
  mkdir -p "$HOME/.config"
  ln -s "$HOME/.dotfiles/mise/config" "$HOME/.config/mise"
elif [ ! -L "$HOME/.config/mise" ]; then
  info 'Backing up existing mise config and linking dotfiles config'
  mv "$HOME/.config/mise" "$HOME/.config/mise.backup"
  ln -s "$HOME/.dotfiles/mise/config" "$HOME/.config/mise"
fi

# Install all tools from config.toml
info 'Installing mise tools'
$MISE install --yes || fail 'mise install failed'

success 'mise tools installed'

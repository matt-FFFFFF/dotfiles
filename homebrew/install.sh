#!/bin/sh

# Homebrew bootstrap + Brewfile install (macOS only).
# Skips silently on Linux.

# Bootstrap Homebrew itself if missing
if test ! "$(which brew)"
then
  if test "$(uname)" = "Darwin"
  then
    echo "  Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

# Put brew on PATH for the rest of this script
if test -x /opt/homebrew/bin/brew
then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif test -x /usr/local/bin/brew
then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Install everything in the Brewfile (idempotent — skips already-installed)
if test "$(uname)" = "Darwin"
then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  brew bundle --file="$SCRIPT_DIR/Brewfile"
fi

#!/bin/sh

# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

if test -x /opt/homebrew/bin/brew
then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif test -x /usr/local/bin/brew
then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Wallpaper CLI — used by bin/theme-set + bin/wallpaper-cycle on macOS
# (proper multi-Space + multi-display coverage; replaces fragile osascript path)
if test "$(uname)" = "Darwin"; then
  brew install wallpaper
fi

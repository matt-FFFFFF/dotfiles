if test ! "$(uname)" = "Darwin"
  then
  exit 0
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

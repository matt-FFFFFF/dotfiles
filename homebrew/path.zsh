if test ! "$(uname)" = "Darwin"
  then
  return
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

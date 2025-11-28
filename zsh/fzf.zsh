if command -v fzf &> /dev/null; then
  alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
  FZF_SHARE_DIR="/usr/share/fzf"
  if [ "$(uname)" = "Darwin" ]; then
    FZF_SHARE_DIR="$(brew --prefix)/opt/fzf/shell"

  fi
  if [[ -f $FZF_SHARE_DIR/completion.zsh ]]; then
    source $FZF_SHARE_DIR/completion.zsh
  fi
  if [[ -f $FZF_SHARE_DIR/key-bindings.zsh ]]; then
    source $FZF_SHARE_DIR/key-bindings.zsh
  fi
fi

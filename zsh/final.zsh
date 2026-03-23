# Load fzf shell integration (key bindings + completion) after vi mode is set
# so that ctrl+r, ctrl+t, and alt+c are not overwritten by bindkey -v
if command -v fzf &> /dev/null; then
  eval "$(fzf --zsh)"
fi

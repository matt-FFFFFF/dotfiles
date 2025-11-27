precmd_functions+=(title)
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

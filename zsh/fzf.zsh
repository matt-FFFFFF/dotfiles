# fzf key bindings + completion via `fzf --zsh` (works regardless of whether
# fzf came from mise, brew or a system package)
if (( $+commands[fzf] )); then
  alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
  cached_eval fzf --zsh
fi

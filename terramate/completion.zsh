if (( $+commands[terramate] )); then
  complete -o nospace -C $commands[terramate] terramate tm
fi

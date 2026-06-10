if (( $+commands[terraform] )); then
  complete -o nospace -C $commands[terraform] terraform t
fi

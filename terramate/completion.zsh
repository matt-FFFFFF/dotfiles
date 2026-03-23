if command -v terramate &> /dev/null; then
  complete -o nospace -C $(which terramate) terramate
  complete -o nospace -C $(which terramate) tm
fi

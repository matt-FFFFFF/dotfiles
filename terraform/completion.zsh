if command -v terraform &> /dev/null; then
  complete -o nospace -C $(which terraform) terraform
  complete -o nospace -C $(which terraform) t
fi

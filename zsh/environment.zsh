if [[ $TERM_PROGRAM == "WarpTerminal" ]]; then
  export STARSHIP_CONFIG=~/.starship-warp.toml
else
  export STARSHIP_CONFIG=~/.starship.toml
fi

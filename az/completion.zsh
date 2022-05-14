if type brew >/dev/null; then
  if [ -f $(brew --prefix)/etc/bash_completion.d/az ]; then
    source $(brew --prefix)/etc/bash_completion.d/az
  fi
fi

if [ "$(uname)" = "Darwin" ]; then
  brew install podman
  podman completion -f "${fpath[1]}/_podman" zsh
fi

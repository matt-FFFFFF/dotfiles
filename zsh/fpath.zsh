# add each topic folder to fpath so that they can add functions and completion scripts
for topic_folder ($ZSH/*) if [ -d $topic_folder ]; then  fpath=($topic_folder $fpath); fi;

# brew zsh-completions
if [ "$(uname)" = "Darwin" ]; then
  if type brew &>/dev/null; then
    fpath=($(brew --prefix)/share/zsh-completions $fpath)
  fi
fi

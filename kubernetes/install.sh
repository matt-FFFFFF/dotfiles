#!/bin/sh

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

info 'Begin Kubernetes'

COMMANDS="curl"
 
# Read the array values with space
for COMMAND in $COMMANDS; do
  if [ ! $(command -v $COMMAND) ]; then
    fail "Could not find '$COMMAND' command. Is it installed?"
  else
    info "Found command $COMMAND: $(command -v $COMMAND)"
  fi
done

unset COMMANDS

cd $HOME

if [ ! -d ~/bin ]; then
    info 'Creating ~/bin'
    mkdir ~/bin
fi

user 'What verison of kubectl would you like? (press <enter> for latest)'
read KUBECTL_VER

if [ -z "$KUBECTL_VER" ]; then
    KUBECTL_VER=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
fi

if [ $(echo $KUBECTL_VER | cut -c1) != 'v' ]; then
    KUBECTL_VER=v$KUBECTL_VER
fi

info "Downloading kubectl version $KUBECTL_VER"

curl --silent -L https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VER/bin/linux/amd64/kubectl --output ~/bin/kubectl

chmod ug+x ~/bin/kubectl

info "$(~/bin/kubectl version)"

success 'Finish Kubernetes'

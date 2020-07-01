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

info 'Begin Docker'

export DEBIAN_FRONTEND=noninteractive

COMMANDS="lsb_release tee gpasswd"
 
# Read the array values with space
for COMMAND in $COMMANDS; do
  if [ ! $(command -v $COMMAND) ]; then
    fail "Could not find '$COMMAND' command. Is it installed?"
  else
    info "Found command $COMMAND: $(command -v $COMMAND)"
  fi
done

sudo apt-get --yes remove docker docker-engine docker.io containerd runc
sudo apt-get update

sudo apt-get --yes install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    curl

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

LSB_RELEASE=$(lsb_release -cs)

info "LSB_RELEASE is: $LSB_RELEASE"

echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $LSB_RELEASE stable" |
    sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update

sudo apt-get install --yes docker-ce-cli 
if [ ! $(uname -a | grep microsoft-standard) ]; then
    sudo apt-get install docker-ce containerd.io
fi

info 'Adding user to docker group'
sudo gpasswd -a $(id -un) docker

if [ -d $ZSH/docker ]; then
 info 'Getting zsh completion'
  curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker -o $ZSH/docker/completion.zsh
fi

success 'Finish Docker'

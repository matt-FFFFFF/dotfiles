#!/bin/sh

# Taken from: [get_golang.sh](https://gist.github.com/n8henrie/1043443463a4a511acf98aaa4f8f0f69)
# Download latest Golang release for AMD64

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

# Ensure paths are correctly set
source $ZSH/go/path.zsh

COMMANDS="wget"
 
# Read the array values with space
for COMMAND in $COMMANDS; do
  if [ ! $(command -v $COMMAND) ]; then
    fail "Could not find '$COMMAND' command. Is it installed?"
  else
    info "Found command $COMMAND: $(command -v $COMMAND)"
  fi
done

set -euf -o pipefail
# Install pre-reqs
##sudo apt-get install python3 git -y
##o=$(python3 -c $'import os\nprint(os.get_blocking(0))\nos.set_blocking(0, True)')

#Download Latest Go
##GOURLREGEX='https://dl.google.com/go/go[0-9\.]+\.linux-amd64.tar.gz'
cd ~
info "Finding latest version of Go for AMD64..."
url="$(wget -qO- https://golang.org/dl/ | grep -oP 'https:\/\/dl\.google\.com\/go\/go([0-9\.]+)\.linux-amd64\.tar\.gz' | head -n 1 )"
latest="$(echo $url | grep -oP 'go[0-9\.]+' | grep -oP '[0-9\.]+' | head -c -2 )"
info "Downloading latest Go for AMD64: ${latest}"
wget --quiet --continue --show-progress "${url}"
unset url
##unset GOURLREGEX

info 'Remove Old Go'
sudo rm -rf /usr/local/go

info 'Install new Go'
sudo tar -C /usr/local -xzf go"${latest}".linux-amd64.tar.gz
info "Create the skeleton for your local user $GOPATH directory"
mkdir -vp $GOPATH/{bin,pkg,src}
info 'Configuring Go paths'
source $ZSH/go/path.zsh
info "Installing dep for dependency management"
go get -u github.com/golang/dep/cmd/dep

# Remove Download
info 'Remove download'
rm ~/go"${latest}".linux-amd64.tar.gz

# Print Go Version
info "$(/usr/local/go/bin/go version)"
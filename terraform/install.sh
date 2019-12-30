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

if [ ! $(command -v jq) ]; then
    fail 'Could not find "jq" command'
fi

if [ ! $(command -v curl) ]; then
    fail 'Could not find "curl" command'
fi

if [ ! $(command -v unzip) ]; then
    fail 'Could not find "unzuip" command'
fi

user ' - What verison of Terraform would you like? (press <enter> for latest)'
read TF_VER

if [ -z "$terraform_version" ]; then
    TF_VER=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
fi

info "Getting https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_linux_amd64.zip"
curl "https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_linux_amd64.zip" --output ~/terraform_${TF_VER}_linux_amd64.zip

if [ ! -d ~/bin ]; then
    info 'Creating ~/bin'
    mkdir ~/bin
fi

cd ~/bin

info 'Unzipping Terraform'
unzip ~/terraform_${TF_VER}_linux_amd64.zip

info 'Removing download'
rm ~/terraform_${TF_VER}_linux_amd64.zip
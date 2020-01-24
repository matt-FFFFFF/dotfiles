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

info 'Begin terraform'

COMMANDS="jq curl unzip"
 
# Read the array values with space
for COMMAND in $COMMANDS; do
  if [ ! $(command -v $COMMAND) ]; then
    fail "Could not find '$COMMAND' command. Is it installed?"
  else
    info "Found command $COMMAND: $(command -v $COMMAND)"
  fi
done

unset COMMANDS

user 'What verison of Terraform would you like? (press <enter> for latest)'
read TF_VER

if [ -z "$TF_VER" ]; then
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

success 'Finish terraform'

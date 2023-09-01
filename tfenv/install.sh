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

info 'Begin tfenv'

sudo apt-get install -y git curl

if [ -d ~/.tfenv ]; then
  rm -fr ~/.tfenv
fi

user 'What verison of Terraform would you like? (press <enter> for latest)'
read TF_VER

if [ -z "$TF_VER" ]; then
    TF_VER=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
fi

git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv

~/.tfenv/bin/tfenv use "$TF_VER"

success 'Finish tfenv'

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

sudo apt-get install -y jq curl unzip

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

user 'What verison of tflint would you like? (press <enter> for latest)'
read TFLINT_VER

if [ -z "$TFLINT_VER" ]; then
    TFLINT_URL="https://github.com/terraform-linters/tflint/releases/latest/download/tflint_linux_amd64.zip"
else
    TFLINT_URL="https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VER}/tflint_linux_amd64.zip"
fi

info "Getting ${TFLINT_URL}"
curl -L $TFLINT_URL --output ~/tflint_linux_amd64.zip

if [ ! -d ~/bin ]; then
    info 'Creating ~/bin'
    mkdir ~/binerraform_${TF_VER}
fi

cd ~/bin

info 'Unzipping Terraform'
unzip ~/terraform_${TF_VER}_linux_amd64.zip

info 'Unzipping tflint'
unzip ~/tflint_linux_amd64.zip

info 'Removing Terraform download'
rm -f ~/terraform_${TF_VER}_linux_amd64.zip

info 'Removing tflint download'
rm -f ~/tflint_linux_amd64.zip

success 'Finish terraform'

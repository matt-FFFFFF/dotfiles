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

info 'Begin az cli'

COMMANDS="gpg tee curl"
 
# Read the array values with space
for COMMAND in $COMMANDS; do
  if [ ! $(command -v $COMMAND) ]; then
    fail "Could not find '$COMMAND' command. Is it installed?"
  else
    info "Found command $COMMAND: $(command -v $COMMAND)"
  fi
done

#######################################################################################################################
# This script does three fundamental things:                                                                          #
#   1. Add Microsoft's GPG Key has a trusted source of apt packages.                                                  #
#   2. Add Microsoft's repositories as a source for apt packages.                                                     #
#   3. Installs the Azure CLI from those repositories.                                                                #
# Given the nature of this script, it must be executed with elevated privileges, i.e. with `sudo`.                    #
#                                                                                                                     #
# Remember, with great power comes great responsibility.                                                              #
#                                                                                                                     #
# Do not be in the habit of executing scripts from the internet with root-level access to your machine. Only trust    #
# well-known publishers.                                                                                              #
#######################################################################################################################

set -e

global_consent=0 # Artificially giving global consent after review-feedback. Remove this line to enable interactive mode

info "Adding packages necessary to modify your apt-package sources"

set -v
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y apt-transport-https lsb-release gnupg curl
set +v

info "Adding Microsoft as a trusted package signer"
set -v
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg >/dev/null
set +v

info "Adding the Azure CLI Repository to your apt sources"
set -v
CLI_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ ${CLI_REPO} main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update
set +v

info "Installing the Azure CLI"
sudo apt-get install -y azure-cli

success 'Finish az cli'

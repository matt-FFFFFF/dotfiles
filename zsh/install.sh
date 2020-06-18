#!/bin/sh

# If we are Debian based, install the extra zsh packages
if [ "$(lsb_release -is)" = "Ubuntu" ] || [ "$(lsb_release -is)" = "Debian" ] ; then
 echo "installing zsh"
 sudo apt-get update
 sudo apt-get -y install zsh zsh-syntax-highlighting zsh-autosuggestions
 echo 'Setting shell to zsh'
 sudo usermod -s $(which zsh) $(id -un)
fi

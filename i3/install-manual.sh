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

info 'Begin regolith'
export DEBIAN_FRONTEND=noninteractive

user 'The Xresources files do not support environment variables - update the paths to point to your home dir!'
user 'press <enter> to confirm'
read nothing

cd "$(dirname "$0")/.."
ROOT=$(pwd -P)
i3CONFIG=$HOME/.config/regolith/i3

if [ ! -d $i3CONFIG ]; then
    info 'Making i3 config directory'
    mkdir -p $i3CONFIG
fi

if [ -f $i3CONFIG/config ]; then
    info 'Removing extisting i3 config'
    rm $i3CONFIG/config
fi

info 'Creating symlink'
ln -s $ROOT/regolith/.config/i3/config $i3CONFIG/config

info 'Installing Regolith'
sudo add-apt-repository -y ppa:kgilmer/regolith-stable
sudo apt install regolith-desktop

info 'Installing Ayu GTK3 theme'
curl -L https://github.com/appelgriebsch/ayu-theme/releases/download/ayu-0.1.0/ayu-theme_0.1.0-1_amd64.deb --output $HOME/ayu-theme_0.1.0-1_amd64.deb
cd $HOME
sudo dpkg -i ./ayu-theme_0.1.0-1_amd64.deb && rm ./ayu-theme_0.1.0-1_amd64.deb

info 'Installing Arc Icon theme'
sudo apt install arc-icon-theme

success 'Finish regolith'

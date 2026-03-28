#!/bin/bash

# Setup script for Fedora toolbox
# Installs and configures Git Credential Manager

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit 1
}

# Git Credential Manager
install_gcm() {
  info 'Installing Git Credential Manager'

  GCM_VERSION=$(curl -s https://api.github.com/repos/git-ecosystem/git-credential-manager/releases/latest | grep -o '"tag_name": *"[^"]*"' | head -1 | grep -o 'v[0-9.]*')
  GCM_VERSION_NUM=${GCM_VERSION#v}
  GCM_URL="https://github.com/git-ecosystem/git-credential-manager/releases/download/${GCM_VERSION}/gcm-linux-x64-${GCM_VERSION_NUM}.tar.gz"

  curl -fLo /tmp/gcm.tar.gz "$GCM_URL" || fail "Failed to download GCM"

  mkdir -p /tmp/gcm-extract
  tar -xzf /tmp/gcm.tar.gz -C /tmp/gcm-extract

  sudo install -m 755 /tmp/gcm-extract/git-credential-manager /usr/local/bin/git-credential-manager
  sudo install -m 755 /tmp/gcm-extract/libHarfBuzzSharp.so /usr/local/bin/libHarfBuzzSharp.so
  sudo install -m 755 /tmp/gcm-extract/libSkiaSharp.so /usr/local/bin/libSkiaSharp.so

  rm -rf /tmp/gcm.tar.gz /tmp/gcm-extract

  # Add /usr/local/lib to ldconfig if not already present
  if ! grep -q '/usr/local/lib' /etc/ld.so.conf.d/*.conf 2>/dev/null; then
    echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/local.conf > /dev/null
    sudo ldconfig
  fi

  git-credential-manager configure

  git config --global credential.credentialStore secretservice

  success "Git Credential Manager ${GCM_VERSION} installed"
}

# xdg-open wrapper so GCM can open browser on the host from inside toolbox
install_xdg_open_wrapper() {
  info 'Installing xdg-open host wrapper'
  cat <<'EOF' | sudo tee /usr/local/bin/xdg-open > /dev/null
#!/bin/bash
exec flatpak-spawn --host xdg-open "$@"
EOF
  sudo chmod +x /usr/local/bin/xdg-open
  success 'xdg-open wrapper installed'
}

if ! command -v git-credential-manager > /dev/null 2>&1; then
  install_gcm
else
  success 'Git Credential Manager already installed'
fi

install_xdg_open_wrapper

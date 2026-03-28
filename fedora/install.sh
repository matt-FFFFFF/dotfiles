#!/bin/bash

# Install layered rpm-ostree packages on Fedora Atomic systems
# (Silverblue, Sericea, Kinoite, etc.)
#
# Packages here are ones that can't be installed inside a toolbox and need
# to be available on the host — e.g. Wayland-specific tools, terminal
# emulators that need GPU/compositor access, etc.

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

# Detect Fedora Atomic: rpm-ostree must exist and the booted deployment must
# be an ostree-managed root (i.e. / is not a normal r/w filesystem).
is_fedora_atomic() {
  command -v rpm-ostree > /dev/null 2>&1 || return 1
  # On Atomic systems, /run/ostree-booted is present
  [ -f /run/ostree-booted ] || return 1
  return 0
}

if ! is_fedora_atomic; then
  exit 0
fi

info 'Fedora Atomic detected — installing layered rpm-ostree packages'

# Packages to layer onto the host OS image.
# Add or remove entries here to match what you want on every Atomic install.
PACKAGES=(
  kitty   # GPU-accelerated terminal emulator (needs host Wayland/GPU access)
  wtype   # xdotool-equivalent for Wayland (needed for sway keybindings)
)

# Determine which packages are already layered so we only pass new ones to
# rpm-ostree (avoids a redundant rebase/deploy cycle).
ALREADY_LAYERED=$(rpm-ostree status --json \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
pkgs = data['deployments'][0].get('requested-packages', [])
print(' '.join(pkgs))
" 2>/dev/null)

TO_INSTALL=()
for pkg in "${PACKAGES[@]}"; do
  if echo "$ALREADY_LAYERED" | grep -qw "$pkg"; then
    info "  already layered: $pkg"
  else
    TO_INSTALL+=("$pkg")
  fi
done

if [ ${#TO_INSTALL[@]} -eq 0 ]; then
  success 'All rpm-ostree packages already layered — nothing to do'
  exit 0
fi

info "  layering: ${TO_INSTALL[*]}"

rpm-ostree install --idempotent --allow-inactive "${TO_INSTALL[@]}" \
  || fail 'rpm-ostree install failed'

success "rpm-ostree packages layered: ${TO_INSTALL[*]}"
info '  A reboot is required for the changes to take effect.'

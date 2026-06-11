#!/bin/sh
# system/install.sh — bootstrap macOS-only LaunchAgent for wallpaper-cycle.
# POSIX sh (NOT bash). Inert on non-Darwin. Auto-discovered by script/install
# (find . -name install.sh ...).

case "$(uname)" in
  Darwin)
    SRC="$HOME/.dotfiles/system/launchd/com.dotfiles.wallpaper-cycle.plist"
    DST="$HOME/Library/LaunchAgents/com.dotfiles.wallpaper-cycle.plist"
    LABEL="com.dotfiles.wallpaper-cycle"

    if [ ! -f "$SRC" ]; then
      echo "WARN: $SRC not found; skipping LaunchAgent install"
      exit 0
    fi

    mkdir -p "$HOME/Library/LaunchAgents" "$HOME/.cache" || exit 0

    sed "s|__HOME__|$HOME|g" "$SRC" > "$DST" || {
      echo "WARN: failed to install $DST"
      exit 0
    }

    # idempotency: unload any prior version (silent on missing)
    launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true

    if launchctl bootstrap "gui/$(id -u)" "$DST"; then
      echo "OK: wallpaper-cycle LaunchAgent loaded"
    else
      echo "WARN: launchctl bootstrap failed (you may need to enable Full Disk Access for your terminal); leaving plist in place"
    fi
    ;;
  *)
    # Non-Darwin: silent no-op
    ;;
esac

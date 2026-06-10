# AGENTS.md

Repo-specific notes for AI agents. Read [README.md](README.md) first for the topic-based dotfiles philosophy; this file only captures things that bite.

## Editing rules

- **Never edit files in `$HOME` directly.** Everything user-visible is a symlink back into this repo. Edit here.
- **`*.symlink` files** symlink to `~/.<basename-without-extension>` (e.g. `tmux/tmux.conf.symlink` → `~/.tmux.conf`).
- **`<topic>/config/` directories** symlink to `~/.config/<topic>/`. Created by [script/bootstrap](script/bootstrap).
- **`functions/*`** are autoloaded via `fpath` (every top-level topic dir is on `fpath` via [zsh/fpath.zsh](zsh/fpath.zsh)). No `source` needed; just put a function named like the file in it.
- **`*.zsh` files** are auto-sourced by [zsh/zshrc.symlink](zsh/zshrc.symlink) in this order: `path*.zsh` → everything else → `completion*.zsh` → `completion_bash*.zsh` → `final*.zsh`. If load order matters, use one of those names.
- **OS / distro scoping** by filename suffix: `*.darwin.zsh` (macOS), `*.linux.zsh` (any Linux), `*.linux.<id>.zsh` where `<id>` matches `ID=` in `/etc/os-release` (e.g. `*.linux.arch.zsh`). The phase (`path`/`completion`/`final`) is still detected after stripping the OS suffix — so `path.darwin.zsh` still loads in the path phase.
- **`install.sh` files** must be POSIX `sh`, not bash. They are NOT auto-sourced; [script/install](script/install) runs them. Files named `_install.sh` run before all `install.sh` (used by `mise/_install.sh` and `system/_install.sh` to bootstrap the toolchain first).

## Toolchain ownership

Read [mise/config/config.toml](mise/config/config.toml) before adding any CLI tool. **mise owns**: sesh, azure-cli, eza, fd, fzf, gh, go, helm, kubectl, lua, powershell, starship, terraform, terramate, uv, zoxide. Do not `brew install` / `dnf install` any of these — add to the mise config instead.

**Per-OS package managers own** what mise can't provide (zsh plugins, tmux binary, system libs). See per-topic `install.sh`.

**`fzf-tmux` wrapper is NOT available** — mise ships only the `fzf` binary. Use `fzf --tmux center,W%,H%` instead (fzf ≥ 0.53). See [bin/scs](bin/scs) and [bin/theme-picker](bin/theme-picker).

## Theme system ([THEMING.md](THEMING.md))

- `themes/<name>/colors.toml` is the source palette.
- `themed/*.tpl` are mustache-ish templates (`{{ key }}`, `{{ key_strip }}`, `{{ key_rgb }}`).
- [bin/theme-set](bin/theme-set) renders templates → writes to `~/.config/...` → live-reloads sway/waybar/dunst/kitty/nvim via their respective IPC sockets.
- [bin/theme-picker](bin/theme-picker) is the fzf/rofi picker. `-v` for verbose, silent by default (important: hotkey use cannot tolerate stdout corrupting the prompt redraw).
- **`kitty/config/colors.conf` IS tracked but is overwritten on every `theme-set` run.** It will frequently show as dirty in `git status`. Do not commit theme-output changes unless intentional.
- **kitty live-reload requires `allow_remote_control yes`** (set in [kitty/config/kitty.conf](kitty/config/kitty.conf)) and the socket path `/tmp/kitty.sock*` (configured via `listen_on unix:/tmp/kitty.sock`).

## Keybind layers

Three layers, ordered from outer to inner: **kitty → tmux → zsh widget**. Each captures keys before passing to the next.

- **zsh widgets** (e.g. [sesh/sesh.zsh](sesh/sesh.zsh), [theme/theme.zsh](theme/theme.zsh)) handle keys at the zsh prompt.
- **tmux root-table binds** (`bind-key -n ...` in [tmux/tmux.conf.symlink](tmux/tmux.conf.symlink)) capture globally inside tmux, **shadowing inner apps** (vim, fzf, etc.). Used for `Alt+S` (sesh) and `Alt+T` (theme) so the same physical key works in native kitty (via zsh widget) and inside tmux (via tmux root bind). This is intentional — Alt+S and Alt+T are not common editor bindings.
- **kitty maps** capture before tmux/zsh ever see the key. Avoid adding picker keybinds here — they tie the workflow to kitty and break under SSH.

## Verifying changes

There is no build/test/lint pipeline. Verify by execution:

- zsh changes → `source ~/.zshrc` or open a fresh shell.
- tmux changes → `prefix + r` (bound to reload).
- kitty changes → `ctrl+shift+f5` (default reload) or restart kitty.
- script changes → run the script directly with representative args.
- theme changes → `theme-set <name>` then visually inspect.

## Performance pattern

[zsh/zshrc.symlink](zsh/zshrc.symlink) defines `cached_eval` for slow `tool init zsh`-style commands. Wrap any new `eval "$(foo init zsh)"` with `cached_eval foo init zsh` so it caches the init output and only regenerates when the tool binary changes. The compinit setup likewise rebuilds asynchronously — do not replace it with a synchronous `compinit` call.

## Commit style

Conventional Commits: `feat(scope): ...`, `fix(scope): ...`, `chore(scope): ...`. Atomic — one logical change per commit. Recent examples: `fix(scs): use fzf --tmux instead of fzf-tmux wrapper`, `feat(tmux): unify picker hotkeys with zsh via root-table binds`. Never commit `git/gitconfig.local.symlink` (it is gitignored and bootstrap-generated).

## Gotchas summary

- macOS `xdg-open` doesn't exist — use `open_url_with default` in kitty (not `xdg-open`).
- macOS Option key sends Unicode unless `macos_option_as_alt left` (already set) — required for `Alt+`-style binds to reach tmux/zsh.
- `set -euo pipefail` + `pipefail` makes a cancelled fzf (exit 130) abort the script. Append `|| selected=""` to picker assignments so cancel falls through cleanly. See [bin/theme-picker](bin/theme-picker).
- `tmux run-shell` is non-interactive but `fzf --tmux` creates its own popup, so it still works.
- `gitconfig.local.symlink` is generated by [script/bootstrap](script/bootstrap) from `git/gitconfig.local.example` on first run; do not check it in.

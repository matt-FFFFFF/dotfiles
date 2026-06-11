# Theming System

A theme-switching system for the Sway desktop stack. Inspired by [omarchy](https://github.com/basecamp/omarchy)'s approach: themes define a `colors.toml` palette, a `theme-set` script substitutes `{{ variable }}` placeholders in templates, and the generated configs are written to `~/.config/`.

Covered apps: **sway**, **waybar**, **rofi**, **dunst**, **swaylock**, **kitty**, **neovim**.

---

## Directory Layout

```
~/.dotfiles/
├── themes/
│   ├── cyan/                       # default — your existing palette
│   │   ├── colors.toml
│   │   └── neovim.lua
│   ├── tokyo-night/
│   │   ├── colors.toml
│   │   ├── neovim.lua
│   │   └── backgrounds/
│   │       └── 1-tokyo.jpg
│   ├── rose-pine/
│   │   ├── colors.toml
│   │   ├── neovim.lua
│   │   └── backgrounds/
│   │       └── 1-rose.jpg
│   ├── nord/
│   │   ├── colors.toml
│   │   ├── neovim.lua
│   │   └── backgrounds/
│   │       └── 1-nord.jpg
│   └── catppuccin-mocha/
│       ├── colors.toml
│       ├── neovim.lua
│       └── backgrounds/
│           └── 1-mocha.jpg
│
├── system/                         # system services and installers
│   ├── install.sh                  # macOS-guarded LaunchAgent installer
│   └── launchd/
│       └── com.dotfiles.wallpaper-cycle.plist
│
├── themed/                         # templates (tracked in git)
│   ├── sway-theme.conf.tpl
│   ├── sway-output.conf.tpl
│   ├── waybar.css.tpl
│   ├── rofi-vars.rasi.tpl
│   ├── dunstrc.tpl
│   ├── swaylock.conf.tpl
│   └── kitty-colors.conf.tpl
│
└── bin/
    ├── theme-set                   # main switching script
    ├── theme-current               # prints active theme name
    ├── theme-picker                # multi-backend picker (tmux popup, rofi, inline fzf)
    ├── theme-test-macos            # smoke test for macOS support
    └── wallpaper-cycle-daemon      # Linux respawn wrapper
```

**Generated outputs** — written to `~/.config/` by `theme-set`:

| Generated file | Template | Tracked in git? |
|---|---|---|
| `~/.config/sway/config.d/05-theme.conf` | `themed/sway-theme.conf.tpl` | no |
| `~/.config/sway/config.d/20-output.conf` | `themed/sway-output.conf.tpl` | no |
| `~/.config/waybar/style.css` | `themed/waybar.css.tpl` + static body | no |
| `~/.config/rofi/theme.rasi` | `themed/rofi-vars.rasi.tpl` | no |
| `~/.config/dunst/dunstrc` | `themed/dunstrc.tpl` | no |
| `~/.config/swaylock/config` | `themed/swaylock.conf.tpl` | no |
| `~/.config/kitty/colors.conf` | `themed/kitty-colors.conf.tpl` | **YES** (symlinked into repo) |
| `~/.config/themes/current.name` | written by `theme-set` | no |
| `~/.config/themes/wallpaper.index` | written by `theme-set` | no |

`kitty/config/` is a topic-config dir, so it symlinks to `~/.config/kitty/`. Writing to `~/.config/kitty/colors.conf` therefore writes through the symlink into the repo at `kitty/config/colors.conf`, which **is** tracked. Expect `git status` to frequently show it dirty after running `theme-set`; do not commit unless intentional.

---

## `colors.toml` Schema

Every theme must have a `colors.toml` with these keys:

```toml
# Neovim integration (consumed by bin/theme-set + the colour.lua shim)
nvim_plugin       = "olimorris/onedarkpro.nvim"  # lazy.nvim repo slug
nvim_colorscheme  = "onedark"                    # name passed to :colorscheme
appearance         = "dark"                       # "dark" | "light" (macOS only; default "dark")
# nvim_plugin_name = "onedarkpro.nvim"           # OPTIONAL — only set if the
                                                 # Lazy plugin name differs
                                                 # from the basename of the
                                                 # repo slug. Defaults to
                                                 # basename(nvim_plugin).

# Core palette
accent             = "#33ccff"
background         = "#0d0d0d"
background_alt     = "#141414"
background_subtle  = "#1f1f1f"
foreground         = "#ffffff"
foreground_dim     = "#999999"
inactive           = "#595959"
urgent             = "#ff5555"
success            = "#00ff99"
warning            = "#ffaa00"
cursor             = "#33ccff"

# Terminal 16-color palette (for kitty)
color0  = "#0d0d0d"
color1  = "#ff5555"
color2  = "#00ff99"
color3  = "#ffaa00"
color4  = "#33ccff"
color5  = "#c792ea"
color6  = "#89ddff"
color7  = "#ffffff"
color8  = "#595959"
color9  = "#ff7b7b"
color10 = "#69ff94"
color11 = "#ffcb6b"
color12 = "#82aaff"
color13 = "#c3a6ff"
color14 = "#89ddff"
color15 = "#ffffff"
```

### Template variable expansions

For each key `foo` in `colors.toml`, three substitution tokens are available in templates:

| Token | Value | Example |
|---|---|---|
| `{{ foo }}` | Raw value | `#33ccff` |
| `{{ foo_strip }}` | Hex without `#` | `33ccff` |
| `{{ foo_rgb }}` | Decimal `R,G,B` | `51,204,255` |

The `_strip` variant is used by swaylock (which does not accept the `#` prefix) and sway border `rgb()` values. The `_rgb` variant is available for future use.

---

## Templates

### `themed/sway-theme.conf.tpl`

Generates `~/.config/sway/config.d/05-theme.conf`. Only the color variable lines are templated; all other sway theme settings (gaps, borders, floats, font, focus behaviour) remain verbatim in the template.

```
# Generated by theme-set — do not edit directly
# vim: ft=swayconfig

set $color_active    {{ accent }}
set $color_inactive  {{ inactive }}
set $color_bg        {{ background }}
set $color_text      {{ foreground }}
set $color_urgent    {{ urgent }}

font pango:monospace 10
default_border          pixel 2
default_floating_border pixel 2
hide_edge_borders       smart
gaps inner 5
gaps outer 8
smart_gaps on

# Window colours           border           background       text             indicator        child_border
client.focused             $color_active    $color_bg        $color_text      $color_active    $color_active
client.focused_inactive    $color_inactive  $color_bg        $color_text      $color_inactive  $color_inactive
client.unfocused           $color_inactive  $color_bg        $color_text      $color_inactive  $color_inactive
client.urgent              $color_urgent    $color_bg        $color_text      $color_urgent    $color_urgent

for_window [class=".*"]  opacity 0.97
for_window [class=".*"]  border pixel 2
for_window [app_id=".*"] border pixel 2
...
```

### `themed/sway-output.conf.tpl`

Generates `~/.config/sway/config.d/20-output.conf`. The wallpaper line is computed by `theme-set` and substituted as `{{ wallpaper_line }}`:

- If `themes/<name>/backgrounds/` exists: `"/path/to/first-image.jpg" fill`
- Otherwise: `{{ background }} solid_color`

```
# Generated by theme-set — do not edit directly
# vim: ft=swayconfig

output * bg {{ wallpaper_line }}
```

### `themed/waybar.css.tpl`

Generates the `@define-color` header block. The static layout rules (padding, workspaces, battery states, etc.) are stored in `waybar/config/style-static.css` and appended after the generated block to form the final `~/.config/waybar/style.css`.

```css
/* Generated by theme-set */
@define-color background        {{ background }};
@define-color background_alt    {{ background_alt }};
@define-color background_subtle {{ background_subtle }};
@define-color accent            {{ accent }};
@define-color foreground        {{ foreground }};
@define-color foreground_dim    {{ foreground_dim }};
@define-color inactive          {{ inactive }};
@define-color urgent            {{ urgent }};
@define-color success           {{ success }};
@define-color warning           {{ warning }};
```

All hardcoded hex values in the static CSS body are replaced with their semantic `@variable` equivalents (e.g. `#0d0d0d` → `@background`, `#33ccff` → `@accent`).

### `themed/rofi-vars.rasi.tpl`

Generates `~/.config/rofi/theme.rasi`. All `.rasi` files import this instead of defining their own palette.

```css
/* Generated by theme-set */
* {
    bg:         {{ background }};
    bg-alt:     {{ background_alt }};
    fg:         {{ foreground }};
    fg-dim:     {{ foreground_dim }};
    accent:     {{ accent }};
    accent-dim: {{ background_alt }};
    inactive:   {{ inactive }};
    urgent:     {{ urgent }};
    border:     2px;
    spacing:    0;
}
```

### `themed/dunstrc.tpl`

Full dunstrc with `{{ }}` tokens only on color values. All layout, geometry, text, icon, and behaviour settings remain static in the template.

Key substituted lines:

```ini
frame_color = "{{ accent }}"

[urgency_low]
    background = "{{ background }}"
    foreground = "{{ foreground_dim }}"
    frame_color = "{{ inactive }}"

[urgency_normal]
    background = "{{ background }}"
    foreground = "{{ foreground }}"
    frame_color = "{{ accent }}"

[urgency_critical]
    background = "{{ background }}"
    foreground = "{{ urgent }}"
    frame_color = "{{ urgent }}"

[screenshots]
    frame_color = "{{ success }}"
    foreground  = "{{ success }}"

[nightlight]
    frame_color = "{{ warning }}"
    foreground  = "{{ warning }}"
```

### `themed/swaylock.conf.tpl`

Uses `{{ key_strip }}` (no `#`) throughout because swaylock does not accept the `#` prefix:

```
color={{ background_strip }}
inside-color={{ background_strip }}
inside-clear-color={{ background_strip }}
inside-caps-lock-color={{ background_alt_strip }}
inside-ver-color={{ background_strip }}
inside-wrong-color={{ background_strip }}

ring-color={{ inactive_strip }}
ring-clear-color={{ accent_strip }}
ring-caps-lock-color={{ warning_strip }}
ring-ver-color={{ accent_strip }}
ring-wrong-color={{ urgent_strip }}

key-hl-color={{ success_strip }}
caps-lock-key-hl-color={{ warning_strip }}
bs-hl-color={{ urgent_strip }}
caps-lock-bs-hl-color={{ urgent_strip }}

text-color={{ foreground_strip }}
text-clear-color={{ accent_strip }}
text-caps-lock-color={{ warning_strip }}
text-ver-color={{ accent_strip }}
text-wrong-color={{ urgent_strip }}

line-uses-ring
separator-color=00000000
daemonize
show-failed-attempts
ignore-empty-password
indicator-radius=80
indicator-thickness=6
```

### `themed/kitty-colors.conf.tpl`

Generates `~/.config/kitty/colors.conf`, which is included from `kitty.conf` via `include colors.conf`. The rest of `kitty.conf` (font, opacity, keymaps, etc.) remains static and tracked in git.

`kitty.conf` also requires `allow_remote_control yes` so that `theme-set` can apply colors live to open windows without restart.

```
# Generated by theme-set
foreground           {{ foreground }}
background           {{ background }}
cursor               {{ cursor }}
cursor_text_color    {{ background }}
selection_foreground {{ foreground }}
selection_background {{ accent }}
active_border_color  {{ accent }}

color0  {{ color0 }}
color1  {{ color1 }}
color2  {{ color2 }}
color3  {{ color3 }}
color4  {{ color4 }}
color5  {{ color5 }}
color6  {{ color6 }}
color7  {{ color7 }}
color8  {{ color8 }}
color9  {{ color9 }}
color10 {{ color10 }}
color11 {{ color11 }}
color12 {{ color12 }}
color13 {{ color13 }}
color14 {{ color14 }}
color15 {{ color15 }}
```

---

## Scripts

### `bin/theme-set`

Main theme-switching script. Usage: `theme-set <theme-name>`

Steps:

1. Validate the theme directory exists under `~/.dotfiles/themes/`
2. Parse `colors.toml` and build a `sed` substitution script for `{{ key }}`, `{{ key_strip }}`, and `{{ key_rgb }}` tokens
3. Determine `wallpaper_line`: first image from `backgrounds/` or solid color fallback
4. Run each template through `sed` and write to its output path
5. Concatenate the generated CSS header + static CSS body into `~/.config/waybar/style.css`
6. Write theme name to `~/.config/themes/current.name` and reset `~/.config/themes/wallpaper.index` to `0`
7. Reload running components (each step is best-effort; skipped silently if the component is not running):
   - `swaymsg reload` — picks up new sway theme and output configs
   - `pkill -SIGUSR1 waybar` — live reload waybar CSS
   - `pkill -x dunst && dunst &` — restart dunst with new config
   - `kitty @ --to unix:/tmp/kitty.sock* set-colors --all --configured ~/.config/kitty/colors.conf` — live-apply to all open kitty windows. Requires `allow_remote_control yes` and the matching `listen_on unix:/tmp/kitty.sock` in `kitty.conf`.
8. Hot-reload neovim colorscheme in any running instances via their sockets:
   ```bash
   for sock in /run/user/$(id -u)/nvim.*.0 \
               ${TMPDIR:-/tmp}/nvim.${USER}/*/nvim.*.0 \
               /tmp/nvim*; do
     [[ -S $sock ]] && nvim --server "$sock" --remote-expr \
       "nvim_exec2('Lazy load <plugin> | colorscheme <name> | redraw!', {})" \
       2>/dev/null || true
   done
   ```
   `<plugin>` comes from `nvim_plugin_name` (falling back to `basename(nvim_plugin)`) and `<name>` comes from `nvim_colorscheme`. `Lazy load` is run before `colorscheme` so a not-yet-loaded lazy plugin gets sourced first.

   **Note: `theme-set` does NOT copy `themes/<name>/neovim.lua` anywhere.** Neovim picks up the new theme via the `colour.lua` shim (see [Neovim Integration](#neovim-integration)).

### `bin/theme-current`

Prints the active theme name:

```bash
#!/bin/bash
cat "$HOME/.config/themes/current.name" 2>/dev/null || echo "(none)"
```

### `bin/theme-picker`

Lists themes (one per line from `~/.dotfiles/themes/`) with the current theme pre-selected, then calls `theme-set` on the selection.

Picker backend is chosen at runtime:

1. **Inside tmux** (`$TMUX` set) and `fzf` available → `fzf --tmux center,60%,50%` popup.
2. **Graphical Linux session** (`$WAYLAND_DISPLAY` or `$DISPLAY` set) and `rofi` available → rofi dmenu themed via `~/.config/rofi/picker.rasi`.
3. **Plain terminal fallback** → inline `fzf --height 40%`.

Flags:

- `-v` / `--verbose` — pass through `theme-set`'s output. Default is silent, because the picker is invoked from hotkeys (zsh widget, tmux popup) where any stdout corrupts the prompt redraw.
- `-h` / `--help` — usage.

Cancel handling: each picker branch appends `|| selected=""` so that an `ESC` (fzf exit 130, rofi cancel) falls through to `exit 0` and never leaks a non-zero exit into `tmux run-shell`.

Bound from three places:

- **Sway**: `$mod+Shift+t` (see [Sway Keybind](#sway-keybind))
- **Native zsh prompt**: `Alt+T` via the `theme-picker-widget` zle widget in [theme/theme.zsh](theme/theme.zsh) (mirrors the `sesh-sessions` / `Alt+S` pattern in [sesh/sesh.zsh](sesh/sesh.zsh))
- **Inside tmux**: `Alt+T` via the root-table bind `bind-key -n M-t run-shell "theme-picker"` in [tmux/tmux.conf.symlink](tmux/tmux.conf.symlink). Root-table means no prefix needed and the key is captured globally inside tmux — so it shadows any inner app's `Alt+T` binding. This is intentional so the same physical key works in native kitty and inside tmux.

---

## Rofi Files

### `rofi/config/theme.rasi` (generated)

Written by `theme-set` from `rofi-vars.rasi.tpl`. Not tracked in git.

### `rofi/config/drun.rasi` (modified)

Add `@import "theme.rasi";` at the top and remove the `*{}` color block. All color references (`@bg`, `@accent`, etc.) continue to work via the imported file.

### `rofi/config/cliphist.rasi` (unchanged)

`@theme "drun"` inherits everything via drun, including the imported theme vars. No changes needed.

### `rofi/config/exit.rasi` (new, tracked in git)

A small static file for the exit confirmation dialog. Imports the generated theme:

```css
@import "theme.rasi"

window    { width: 160px; }
listview  { lines: 2; }
inputbar  { enabled: false; }
element-text { vertical-align: 0.5; }
```

`sway/exit.sh` updated: `-theme ~/.config/rofi/omarchy.rasi` → `-theme ~/.config/rofi/exit.rasi`, and the `-theme-str` overrides removed (now in the file).

---

## Neovim Integration

This dotfiles repo does **not** contain a neovim config — it lives in a separate repo at `~/.config/nvim/`. The integration is two-sided:

**This repo provides** per-theme `themes/<name>/neovim.lua` lazy.nvim plugin specs:

```lua
-- themes/tokyo-night/neovim.lua
return {
  { "folke/tokyonight.nvim", priority = 1000 },
  { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight-night" } },
}
```

**The external nvim config provides** `~/.config/nvim/lua/plugins/colour.lua`, a shim that:

1. Reads the active theme name from `~/.config/themes/current.name`
2. Globs `~/.dotfiles/themes/*/neovim.lua` and `dofile()`'s each one
3. Returns a merged lazy plugin spec: the **active** theme eager (`priority = 1000`); inactive themes installed but `lazy = true` with `config` / `opts` stripped (so their colorschemes are installed and switchable but don't auto-apply)
4. Falls back to a sane default if `~/.dotfiles/themes/` is absent

Active-theme detection is by file existence, so `theme-set` does **not** need to write anything into `~/.config/nvim/`. Updating `current.name` is enough for the *next* nvim start to pick up the new theme.

For **live** hot-reload of already-running nvim instances, `theme-set` connects to each nvim Unix socket and runs `Lazy load <plugin> | colorscheme <name>` via `nvim --remote-expr`. The plugin name comes from `nvim_plugin_name` (falling back to `basename(nvim_plugin)`) and the colorscheme from `nvim_colorscheme` — both keys in `colors.toml`. `Lazy load` is run before `colorscheme` so a not-yet-sourced lazy plugin gets loaded first.

---

## Picker Keybinds

`bin/theme-picker` is bound from three layers so the same UX works in every context — see the [`bin/theme-picker`](#bintheme-picker) section above for details.

| Layer | Binding | Where |
|---|---|---|
| Sway (graphical) | `$mod+Shift+t` | `sway/config.d/40-apps.conf`: `bindsym $mod+shift+t exec ~/.dotfiles/bin/theme-picker` |
| Native zsh prompt | `Alt+T` | [`theme/theme.zsh`](theme/theme.zsh) → [`functions/theme-picker-widget`](functions/theme-picker-widget) |
| Inside tmux | `Alt+T` | [`tmux/tmux.conf.symlink`](tmux/tmux.conf.symlink): `bind-key -n M-t run-shell "theme-picker"` |

The same physical key (`Alt+T`) works inside tmux and at the native zsh prompt because the tmux root-table bind (`-n`) intercepts the key before any inner program (including zsh) sees it. Note this also means `Alt+T` will not reach editors / TUIs running inside tmux — chosen deliberately because it is not a common editor binding.

---

## Initial Themes

| Theme | Accent | Background | Neovim plugin |
|---|---|---|---|
| **cyan** | `#33ccff` | `#0d0d0d` | `olimorris/onedarkpro.nvim` (`onedark`) |
| **tokyo-night** | `#7aa2f7` | `#1a1b26` | `folke/tokyonight.nvim` (`tokyonight-night`) |
| **rose-pine** | `#c4a7e7` | `#191724` | `rose-pine/neovim` (`rose-pine`) |
| **nord** | `#88c0d0` | `#2e3440` | `arcticicestudio/nord-vim` (`nord`) |
| **catppuccin-mocha** | `#cba6f7` | `#1e1e2e` | `catppuccin/nvim` (`catppuccin-mocha`) |

---

## Bootstrap (fresh clone)

After symlinking dotfiles, run once to generate all config files:

```bash
theme-set cyan
```

This writes all generated configs from the `cyan` theme (your original palette) and sets up `~/.config/themes/current.name`. No visual change on first run — it just instantiates the system.

---

## Adding a New Theme

1. Create `~/.dotfiles/themes/<name>/colors.toml` with all required keys
2. Create `~/.dotfiles/themes/<name>/neovim.lua` with the lazy plugin spec
3. Optionally add background images to `~/.dotfiles/themes/<name>/backgrounds/`
4. Run `theme-set <name>`

Themes can override any generated file by shipping a pre-built version (e.g. a `waybar.css` that completely replaces the template output). `theme-set` copies theme-specific files before running templates, and templates skip files that already exist in the output.

---

## macOS Support

On macOS, `theme-set` applies the wallpaper, text highlight color, system accent color (closest preset), and appearance mode via `defaults` and `osascript`. Linux-specific components like Sway, Waybar, Dunst, Rofi, and Swaylock remain as no-ops; their reload steps are best-effort and skip silently when their binaries or configs are absent.

### What gets applied on macOS

- **Wallpaper**: Applied to all displays and Spaces using `osascript` to set the picture from `themes/<name>/backgrounds/`.
- **Text-selection highlight color**: Set via `defaults write -g AppleHighlightColor`. The theme's `accent` hex is converted to the required "R G B Other" float format.
- **System accent color**: Set via `defaults write -g AppleAccentColor` using the closest of macOS's 8 presets (red, orange, yellow, green, blue, purple, pink) to the theme's `accent` color.
- **Appearance mode**: Driven by the `appearance` key in `colors.toml`, this sets `defaults write -g AppleInterfaceStyle Dark` (or deletes the key for light mode).
- **Auto-switch**: `AppleInterfaceStyleSwitchesAutomatically` is pinned to `false` so the theme choice remains constant.
- **UI reload**: The `Dock`, `SystemUIServer`, `ControlCenter`, and `Finder` are restarted after `defaults` writes to ensure changes take effect.

### The `appearance` key

The `colors.toml` schema includes an optional `appearance` field. Valid values are `"dark"` and `"light"`. If missing, it defaults to `"dark"`. When `theme-set` runs, it explicitly disables `AppleInterfaceStyleSwitchesAutomatically`, ensuring macOS does not flip the appearance at sunrise or sunset.

### First-run: TCC Automation permission

The first time `theme-set` runs from a terminal emulator (e.g., kitty), macOS displays a TCC (Transparency, Consent, and Control) dialog asking if the terminal may control "System Events". You must click **Allow**. If `theme-set` runs non-interactively first (such as via a launchd LaunchAgent), the prompt will not appear and `osascript` calls for wallpaper settings will silently fail. It's recommended to run `theme-set <name>` once interactively before relying on automated rotation.

### Wallpaper rotation on macOS

On macOS, `bin/wallpaper-cycle` acts as a one-shot script that sets the next wallpaper and exits. Scheduling is handled by launchd via `system/launchd/com.dotfiles.wallpaper-cycle.plist`, which is configured to run every hour. Installation is handled automatically by `script/install` via `system/install.sh`. To manually re-bootstrap the agent:

```sh
launchctl bootout gui/$(id -u)/com.dotfiles.wallpaper-cycle
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.dotfiles.wallpaper-cycle.plist
```

The installer instantiates a real plist in `~/Library/LaunchAgents/` rather than a symlink to ensure launchd reliability.

### Accent color preset mapping

macOS supports 8 preset accent colors: red (0), orange (1), yellow (2), green (3), blue (4), purple (5), and pink (6). Graphite (-1) is excluded from auto-mapping. `theme-set` calculates the closest preset by Euclidean RGB distance to the theme's `accent`. These reference RGB values are approximate and may vary slightly between macOS versions.

### What does NOT change on macOS

- **Dock**: Layout, icons, and position are not theme-driven.
- **Menu bar**: Contents are not affected by the theme engine.
- **Terminal apps**: Beyond kitty, other terminal emulators (like Ghostty or Terminal.app) do not have templates in this system.

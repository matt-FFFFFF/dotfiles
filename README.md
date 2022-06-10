# matt-FFFFFF does dotfiles
(forked from [holman/dotfiles](https://github.com/holman/dotfiles))

Your dotfiles are how you personalize your system. These are mine.

**Designed to be used on Ubuntu/macOS**

Time and time again I found myself recreating aliases, install scripts,etc.
This is a way of standardising things :)

If you're interested in the philosophy behind why projects like these are
awesome, you might want to [read Zach's post on the
subject](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/).

## topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
files in there. Anything with an extension of `.zsh` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `script/bootstrap`.

## what's inside

- Azure CLI
- Terraform
- Kubernetes (kubectl)
- Golang
- Teams for Linux
- Regolith (i3 Windows Manager for Ubuntu)

A lot of stuff. Seriously, a lot of stuff. Check them out in the file browser
above and see what components may mesh up with you.
[Fork it](https://github.com/matt-FFFFFF/dotfiles/fork), remove what you don't
use, and build on what you do use.

## components

There's a few special items in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **functions/**: A place to keep the zsh functions that don't belong anywhere else.
  Actually, they can be anywhere as each directory is placed into ```fpath``` by ```zsh/fpath.zsh```.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded
  second to last and is expected to setup autocomplete.
- **topic/final.zsh**: Any file named `final.zsh` is loaded
  last and is used for tasks that depend on completion.
- **topic/install.sh**: Any file named `install.sh` is executed when you run `script/install`.
  To avoid being loaded automatically, its extension is `.sh`, not `.zsh`.
- **topic/\*.symlink**: Any file dor directory ending in `*.symlink` gets symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.

## install

Run this:

```sh
git clone https://github.com/matt-FFFFFF/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

`dot` is a simple script that installs some dependencies, sets sane macOS
defaults, and so on. Tweak this script, and occasionally run `dot` from
time to time to keep your environment fresh and up-to-date. You can find
this script in `bin/`.

## bugs

Many of the install scripts are designed to work on **Ubuntu**, so no surprises that this might not work on Mac OS.
I'm now using Arch so I need to refactor this to cope with the two package systems.
That said, I do use this as _my_ dotfiles, so there's a good chance I may break something if I forget to make a check for a dependency.

If you're brand-new to the project and run into any blockers, please
[open an issue](https://github.com/matt-FFFFFF/dotfiles/issues) on this repository.

## thanks

Taken from Zach Holman's [project](https://github.com/holman/dotfiles).
He in turn thanks [Ryan Bates](http://github.com/ryanb)' for his excellent
[dotfiles](http://github.com/ryanb/dotfiles).

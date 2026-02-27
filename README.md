# dotfiles

Personal configuration files for Neovim and Ghostty, managed with symlinks.

## Structure

```
nvim/       Neovim config (Lua, lazy.nvim)
ghostty/    Ghostty terminal config
setup.sh    Symlinks configs to ~/.config
```

## Setup

1. Install [Neovim](https://neovim.io) and [Ghostty](https://ghostty.org)
2. Clone and run:

```sh
git clone git@github.com:DarthJarJarJar/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```

Existing configs in `~/.config` are backed up to `*.bak` before symlinking.

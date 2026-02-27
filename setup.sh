#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Back up existing configs
for dir in nvim ghostty; do
    if [ -e "$HOME/.config/$dir" ]; then
        echo "Backing up ~/.config/$dir to ~/.config/$dir.bak"
        mv "$HOME/.config/$dir" "$HOME/.config/$dir.bak"
    fi
done

# Create symlinks
mkdir -p "$HOME/.config"
ln -s "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
ln -s "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"

echo "Done!"

#!/bin/bash

set -e

echo "🌌 Hyprland Dotfiles Installer"
echo "This will overwrite your existing configs. Backups will be created."

# Backup directory with timestamp
BACKUP_DIR="$HOME/config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# List of config directories to manage
CONFIG_DIRS=(hypr kitty swaync waybar wlogout wofi)

# Backup existing configs
for dir in "${CONFIG_DIRS[@]}"; do
  if [ -d "$HOME/.config/$dir" ]; then
    echo "Backing up $dir → $BACKUP_DIR/$dir"
    cp -r "$HOME/.config/$dir" "$BACKUP_DIR/"
    rm -rf "$HOME/.config/$dir"
  fi
done

# Copy new configs
for dir in "${CONFIG_DIRS[@]}"; do
  if [ -d "$HOME/.config/hyprland-dotfiles/$dir" ]; then
    echo "Installing $dir config..."
    cp -r "$HOME/.config/hyprland-dotfiles/$dir" "$HOME/.config/"
  fi
done

# Install base dependencies (Arch Linux official repos)
echo "📦 Installing base dependencies with pacman..."
sudo pacman -S --needed base-devel git hyprland hyprlock kitty swaync waybar wlogout wofi ttf-jetbrains-mono-nerd

# Setup yay (AUR helper)
if ! command -v yay &> /dev/null; then
  echo "⚡ yay not found. Installing yay (AUR helper)..."
  cd ~/.config
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  echo "✅ yay installed successfully!"
else
  echo "✅ yay is already installed."
fi

echo "✅ Installation complete!"
echo "Reload Hyprland with: hyprctl reload"
echo "Backups saved in: $BACKUP_DIR"


#!/bin/bash

set -e

echo "Hyprland Dotfiles Installer"
echo "This will overwrite your existing configs. Backups will be created."

# --- Step 1: Ensure Internet Connection ---
echo "Checking internet connection..."
if ! ping -c 1 archlinux.org &>/dev/null; then
  echo "No internet detected. Let's connect using nmcli."
  echo "Available Wi-Fi networks:"
  nmcli device wifi list
  echo "Enter the SSID you want to connect to:"
  read SSID
  echo "Enter the Wi-Fi password (leave blank if open network):"
  read -s PASSWORD
  if [ -z "$PASSWORD" ]; then
    nmcli device wifi connect "$SSID"
  else
    nmcli device wifi connect "$SSID" password "$PASSWORD"
  fi

  # Verify connection
  if ping -c 1 archlinux.org &>/dev/null; then
    echo "Internet connection established."
  else
    echo "❌ Failed to connect. Please check your Wi-Fi settings and rerun the script."
    exit 1
  fi
else
  echo "Internet connection detected."
fi

# --- Step 2: Backup existing configs ---
BACKUP_DIR="$HOME/config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

CONFIG_DIRS=(hypr kitty swaync waybar wlogout wofi)

for dir in "${CONFIG_DIRS[@]}"; do
  if [ -d "$HOME/.config/$dir" ]; then
    echo "Backing up $dir → $BACKUP_DIR/$dir"
    cp -r "$HOME/.config/$dir" "$BACKUP_DIR/"
    rm -rf "$HOME/.config/$dir"
  fi
done

# --- Step 3: Copy new configs ---
for dir in "${CONFIG_DIRS[@]}"; do
  if [ -d "$HOME/.config/hyprland-dotfiles/$dir" ]; then
    echo "Installing $dir config..."
    cp -r "$HOME/.config/hyprland-dotfiles/$dir" "$HOME/.config/"
  fi
done

# --- Step 4: Install base dependencies ---
echo "Installing base dependencies with pacman..."
sudo pacman -S --needed base-devel eog file-roller gedit git \
  hyprland hyprlock amberol kitty swaync waybar wofi \
  ttf-jetbrains-mono-nerd unzip nodejs npm \
  bluez blueman brightnessctl firefox nautilus \
  networkmanager nm-connection-editor pavucontrol zsh vlc \
  swww pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber

# --- Step 5: Enable essential services ---
echo "Enabling system services..."
systemctl --user enable --now pipewire
systemctl --user enable --now pipewire-pulse
systemctl --user enable --now wireplumber
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth

# --- Step 6: Setup yay (AUR helper) ---
if ! command -v yay &> /dev/null; then
  echo "yay not found. Installing yay (AUR helper)..."
  cd ~/.config
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  echo "yay installed successfully!"
else
  echo "yay is already installed."
fi

# --- Step 7: Install AUR packages ---
echo "Installing AUR packages with yay..."
yay -S --needed wlogout grimblast

echo "Installation complete!"
echo "Reload Hyprland with: hyprctl reload"
echo "Backups saved in: $BACKUP_DIR"

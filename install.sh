#!/bin/bash

set -e

echo "Hyprland Dotfiles Installer"
echo "This will overwrite your existing configs. Backups will be created."

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

echo "Checking internet connection..."
if ! ping -c 1 archlinux.org &>/dev/null; then
  echo "No internet detected. Let's connect using nmcli."
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

  if ping -c 1 archlinux.org &>/dev/null; then
    echo "Internet connection established."
  else
    echo "Failed to connect. Please check your Wi-Fi settings and rerun the script."
    exit 1
  fi
else
  echo "Internet connection detected."
fi

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

echo "Installing configs from: $SCRIPT_DIR"
mkdir -p "$HOME/.config"

for dir in "${CONFIG_DIRS[@]}"; do
  if [ -d "$SCRIPT_DIR/$dir" ]; then
    echo "Installing $dir config..."
    cp -r "$SCRIPT_DIR/$dir" "$HOME/.config/"

    if [ "$dir" == "wofi" ]; then
      echo "Patching Wofi configuration path..."
      sed -i "s|USER_HOME|$HOME|g" "$HOME/.config/wofi/config"
    fi
  else
    echo "Skipping $dir: Folder not found in $SCRIPT_DIR"
  fi
done

echo "Installing base dependencies..."
sudo pacman -S --needed base-devel btop eog file-roller gedit git \
  hyprland hyprlock amberol kitty swaync waybar wofi \
  ttf-jetbrains-mono-nerd unzip nodejs npm noto-fonts-emoji noto-fonts-cjk noto-fonts \
  bluez blueman brightnessctl firefox nautilus neovim \
  networkmanager nm-connection-editor pavucontrol vlc polkit-gnome ntfs-3g\
  swww pipewire pipewire-alsa pipewire-pulse pipewire-jack qbittorrent wireplumber \

sudo systemctl enable --now NetworkManager bluetooth
systemctl --user enable --now pipewire pipewire-pulse wireplumber
fc-cache -fv

if ! command -v yay &> /dev/null; then
  echo "Installing yay..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay && makepkg -si --noconfirm && cd -
else
  echo "yay is already installed."
fi

yay -S --needed wlogout grimblast google-chrome ani-cli

echo "Installation complete!"
echo "Backups saved in: $BACKUP_DIR"
hyprctl reload || echo "Hyprland not running, skip reload."

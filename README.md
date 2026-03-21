# 🌌 Hyprland Dotfiles

<p>Minimalist, expressive Hyprland setup with Waybar, Kitty, SwayNC, Wlogout, and Wofi.  
This repo contains my personal configuration files — installing them will replace your current configs, but don’t worry : the installer automatically creates a backup of your existing setup so you can restore it anytime.</p>

<hr>

<h2>🚀 Getting Started</h2>

<h3>1. Clone the repo:</h3>
<pre><code>git clone https://github.com/bhavi-th/hyprland.git
cd hyprland/
</code></pre>

<h3>2. Run the installer</h3>
<pre><code>chmod +x install.sh
./install.sh
</code></pre>

<p>The installer will:</p>
<ul>
   <li>Backup your existing configs into <code>~/config-backup-YYYYMMDD-HHMMSS</code></li>
   <li>Copy my configs into <code>~/.config/</code></li>
   <li>Install required dependencies (Arch Linux / pacman)</li>
</ul>

<h3>3. Reload Hyprland</h3>
<pre><code>hyprctl reload
</code></pre>

<h2>Dependencies</h2>
<p>The installer will install these automatically:</p>
<ul>
   <li><code>hyprland</code></li>
   <li><code>hyprlock</code></li>
   <li><code>kitty</code></li>
   <li><code>file-roller</code></li>
   <li><code>eog</code></li>
   <li><code>gedit</code></li>
   <li><code>amberol</code></li>
   <li><code>grimblast</code></li>
   <li><code>wlogout</code></li>
   <li><code>wofi</code></li>
   <li><code>ttf-jetbrains-mono-nerd</code></li>
   <li><code>yay</code> (AUR helper, cloned into <code>~/.config/yay</code>)</li>
</ul>
and many more...

<h2>🎨 Customize</h2>
<ul>
   <li>Fonts → Edit Waybar CSS or Kitty config to swap JetBrainsMono Nerd Font.</li>
   <li>Colors → Adjust <code>hyprland.conf</code> for borders, backgrounds, and highlights.</li>
   <li>Keybindings → All bindings are in <code>hyprland.conf</code>.</li>
</ul>

<h3>🛠️ Troubleshooting</h3>
<ul>
  <li>Configs not applied → Ensure you ran <code>install.sh</code> and copied into <code>~/.config/</code>.</li>
  <li>Waybar missing modules → Check dependencies are installed.</li>
  <li>Hyprland reload fails → Log out and back in to apply changes.</li>
  <li>yay not working → Navigate to <code>~/.config/yay</code> and run <code>git pull && makepkg -si</code> to update.</li>
</ul>

<h3>🤝 Contributing</h3>
<p>Feel free to fork and adapt. Pull requests welcome for improvements, new themes, or workflow scripts.</p>

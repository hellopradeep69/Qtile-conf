#!/usr/bin/env bash
# setup_qtile.sh
# Qtile + related tools setup script

# -------------------------
# Variables
# -------------------------
CONFIG_REPO="$HOME/Qtile_conf"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"

PACKAGES=(
    cmake picom rofi wezterm alacritty fish neovim btop lxappearance
    feh dunst git curl wget fzf tmux bat unzip
)

# -------------------------
# Create necessary directories
# -------------------------
mkdir -p "$CONFIG_DIR"
mkdir -p "$LOCAL_BIN"

# -------------------------
# Functions
# -------------------------

Copy_it() {
    mkdir -p "$CONFIG_DIR/qtile" "$CONFIG_DIR/picom" "$CONFIG_DIR/dunst" \
        "$CONFIG_DIR/fish" "$CONFIG_DIR/rofi" "$CONFIG_DIR/zathura" \
        "$CONFIG_DIR/fastfetch" "$HOME/Pictures/Wallpapers"

    cp -r "$CONFIG_REPO/qtile/." "$CONFIG_DIR/qtile/"
    cp -r "$CONFIG_REPO/picom/." "$CONFIG_DIR/picom/"
    cp -r "$CONFIG_REPO/dunst/." "$CONFIG_DIR/dunst/"
    cp -r "$CONFIG_REPO/fish/." "$CONFIG_DIR/fish/"
    cp -r "$CONFIG_REPO/rofi/." "$CONFIG_DIR/rofi/"
    cp -r "$CONFIG_REPO/zathura/." "$CONFIG_DIR/zathura/"
    cp -r "$CONFIG_REPO/fastfetch/." "$CONFIG_DIR/fastfetch/"
    cp "$CONFIG_REPO/starship.toml" "$CONFIG_DIR/starship.toml"
    cp "$CONFIG_REPO/tmux.conf" "$HOME/.tmux.conf"
    cp "$CONFIG_REPO/wezterm.lua" "$HOME/.wezterm.lua"
    cp -r "$CONFIG_REPO/scripts/." "$LOCAL_BIN/"
    cp -r "$CONFIG_REPO/Wallpaper/." "$HOME/Pictures/Wallpapers/"
    cp -r "$CONFIG_REPO/Desktop/." "$HOME/.local/share/applications/"
}

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

install_packages() {
    distro=$(detect_distro)
    echo "==> Detected distro: $distro"
    case "$distro" in
    arch | manjaro | endeavouros)
        sudo pacman -Syu --needed --noconfirm "${PACKAGES[@]}"
        ;;
    debian | ubuntu | linuxmint)
        sudo apt update && sudo apt install -y "${PACKAGES[@]}"
        ;;
    fedora)
        sudo dnf install -y "${PACKAGES[@]}"
        ;;
    opensuse* | suse)
        sudo zypper install -y "${PACKAGES[@]}"
        ;;
    *)
        echo "⚠️ Unsupported distro: $distro"
        echo "Please install these packages manually: ${PACKAGES[*]}"
        ;;
    esac
}

Install_fzf() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

Install_neovim() {
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
    chmod u+x nvim-linux-x86_64.appimage

    mkdir -p /opt/nvim
    sudo mv nvim-linux-x86_64.appimage /opt/nvim/nvim
}

Install_starship() {
    curl -sS https://starship.rs/install.sh | sh
}

Install_font() {
    mkdir -p ~/.local/share/fonts

    wget -O JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip JetBrainsMono.zip -d ~/.local/share/fonts
    fc-cache -fv

}

Install_font1() {

    mkdir -p ~/.local/share/fonts

    wget -O Terminus.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Terminus.zip
    unzip Terminus.zip -d ~/.local/share/fonts
    fc-cache -fv
}

Install_fastfetch() {
    (
        git clone https://github.com/fastfetch-cli/fastfetch.git
        cd fastfetch || exit
        mkdir -p build
        cd build || exit
        cmake ..
        cmake --build . --target fastfetch
    )
}

Install_nvimconf() {
    mkdir -p "$HOME/.config/nvim"
    git clone https://github.com/hellopradeep69/Hello-Nvim.git "$HOME/.config/nvim"
    rm -rf "$HOME/.config/nvim/.git" "$HOME/.config/nvim/README.md"
}

Install_zen() {
    wget https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz
    sudo mkdir -p /opt/zen
    sudo tar -xf zen.linux-x86_64.tar.xz -C /opt/zen
    sudo chmod +x /opt/zen/zen
    sudo ln -s /opt/zen/zen /usr/local/bin/zen
}

# -------------------------
# 3️⃣ Copy configuration files
# -------------------------
echo "Copying configs..."
Copy_it

# Make scripts executable
chmod -R +x "$LOCAL_BIN"

echo "Configs copied successfully!"

# -------------------------
# 4️⃣ Install packages
# -------------------------
echo "Installing necessary packages..."
install_packages
echo "Packages installed!"

# Install fzf
echo "Installing Fzf..."
Install_fzf

#Installing nvim
echo "Installing Neovim..."
Install_neovim

# Installing starship
echo "Installing starship..."
Install_starship

# Install font
echo "Installing Fonts"
Install_font
echo "....."
Install_font1

# Install fastfetch
echo "Installing fastfetch"
Install_fastfetch

# Install neovim config
echo " Install neovim config "
Install_nvimconf

# -------------------------
# 5️⃣ Enable starship for fish
# -------------------------
if ! grep -q "starship init" "$HOME/.config/fish/config.fish"; then
    echo "starship init fish | source" >>"$HOME/.config/fish/config.fish"
fi

# -------------------------
# 6️⃣ Set up autostart
# -------------------------
echo "Ensure autostart.sh is executable..."
if [ -f "$CONFIG_DIR/qtile/autostart.sh" ]; then
    chmod +x "$CONFIG_DIR/qtile/autostart.sh"
fi

# -------------------------
# 7️⃣ Done
# -------------------------
echo "Setup complete! You can now restart Qtile or your system."

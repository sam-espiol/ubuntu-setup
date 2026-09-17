#!/bin/bash

# Dừng script nếu có lệnh bị lỗi
set -e

echo "=========================================="
echo "1. Cập nhật hệ thống"
echo "=========================================="
sudo apt update && sudo apt upgrade -y

echo "=========================================="
echo "2. Cài đặt các công cụ cơ bản (Git, GCC, G++, htop...)"
echo "=========================================="
# build-essential sẽ bao gồm gcc, g++, make...
sudo apt install -y curl wget gpg apt-transport-https software-properties-common htop git build-essential gnome-tweaks gnome-shell-extensions gnome-shell-extension-manager

echo "=========================================="
echo "3. Cài đặt KVM và các công cụ ảo hoá"
echo "=========================================="
sudo apt install -y qemu-system qemu-utils libvirt-daemon-system libvirt-clients bridge-utils virt-manager
sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

echo "=========================================="
echo "4. Cài đặt Sublime Text"
echo "=========================================="
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list > /dev/null
sudo apt update
sudo apt install -y sublime-text

echo "=========================================="
echo "5. Cài đặt Visual Studio Code"
echo "=========================================="
curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg > /dev/null
echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
sudo apt update
sudo apt install -y code

echo "=========================================="
echo "6. Cài đặt Brave Browser"
echo "=========================================="
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null
sudo apt update
sudo apt install -y brave-browser

echo "=========================================="
echo "7. Cấu hình GNOME Dock (Minimize & Previews)"
echo "=========================================="
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'

echo "=========================================="
echo "8. Tự động cài đặt Extension: Clipboard Indicator"
echo "=========================================="
CLIPBOARD_EXT_UUID="clipboard-indicator@tudmotu.com"
EXT_DIR="$HOME/.local/share/gnome-shell/extensions/$CLIPBOARD_EXT_UUID"

# Tạo thư mục và tải extension từ GitHub về
mkdir -p "$EXT_DIR"
wget -qO- https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator/archive/refs/heads/master.tar.gz | tar xz --strip-components=1 -C "$EXT_DIR"

# Biên dịch schema (bắt buộc đối với extension GNOME)
glib-compile-schemas "$EXT_DIR/schemas"

# Kích hoạt extension
gnome-extensions enable "$CLIPBOARD_EXT_UUID" || echo "Có thể cần khởi động lại GNOME để extension nhận diện."

echo "=========================================="
echo "9. Cấu hình shortcut"
echo "=========================================="
echo "=========================================="
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super><Shift>s']"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"

echo "=========================================="
echo "Removing Firefox (Snap & APT)"
echo "=========================================="
# Remove Snap version (standard on Ubuntu 22.04/24.04+) and APT package
sudo snap remove firefox 2>/dev/null || true
sudo apt purge -y firefox firefox-locale-* 2>/dev/null || true
rm -rf ~/.mozilla ~/.cache/mozilla

echo "=========================================="
echo "Disabling & Clearing File Thumbnails"
echo "=========================================="
# Disable thumbnail previews in Nautilus (Files)
gsettings set org.gnome.nautilus.preferences show-image-thumbnails 'never'
# Clear existing cached thumbnails
rm -rf ~/.cache/thumbnails/*

echo "=========================================="
echo "Downloading Latest Kali Linux Installer ISO"
echo "=========================================="
# Dynamically fetch the filename for the latest stable installer ISO
KALI_ISO=$(curl -s https://cdimage.kali.org/current/ | grep -oP 'kali-linux-\d+\.\d+[a-z]?-installer-amd64\.iso' | head -n 1)

if [ -n "$KALI_ISO" ]; then
    echo "Downloading $KALI_ISO to ~/Downloads..."
    wget -c "https://cdimage.kali.org/current/$KALI_ISO" -P "$HOME/Downloads"
else
    echo "Downloading Kali ISO to ~/Downloads..."
    wget -c "https://cdimage.kali.org/current/kali-linux-installer-amd64.iso" -O "$HOME/Downloads/kali-linux-installer.iso"
fi

echo "CÀI ĐẶT HOÀN TẤT TOÀN BỘ!"
echo "LƯU Ý QUAN TRỌNG:"
echo "1. Bạn BẮT BUỘC phải KHỞI ĐỘNG LẠI MÁY (Restart) để các quyền của KVM (libvirt) và GNOME Extensions hoạt động chính xác."
echo "2. Sau khi khởi động lại, biểu tượng Clipboard sẽ xuất hiện trên thanh Top Bar của màn hình."
echo "=========================================="

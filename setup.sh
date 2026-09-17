#!/bin/bash

# Dừng script nếu có lệnh bị lỗi
set -e

echo "=========================================="
echo "1. Cập nhật hệ thống"
echo "=========================================="
sudo apt update && sudo apt upgrade -y

echo "=========================================="
echo "2. Cài đặt các gói cơ bản và GNOME Tools"
echo "=========================================="
# Cài đặt htop, gnome-tweaks, và extension manager (công cụ quản lý extension hiện đại cho Ubuntu)
sudo apt install -y curl wget gpg apt-transport-https software-properties-common htop gnome-tweaks gnome-shell-extensions gnome-shell-extension-manager

echo "=========================================="
echo "3. Cài đặt Sublime Text"
echo "=========================================="
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list > /dev/null
sudo apt update
sudo apt install -y sublime-text

echo "=========================================="
echo "4. Cài đặt Visual Studio Code"
echo "=========================================="
curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg > /dev/null
echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
sudo apt update
sudo apt install -y code

echo "=========================================="
echo "5. Cài đặt Brave Browser"
echo "=========================================="
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null
sudo apt update
sudo apt install -y brave-browser

echo "=========================================="
echo "6. Cấu hình GNOME Dock (Minimize & Previews)"
echo "=========================================="
# Thiết lập hành vi click vào Dock: 
# - 1 cửa sổ -> Minimize
# - Nhiều cửa sổ -> Hiển thị Previews
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'

echo "=========================================="
echo "CÀI ĐẶT HOÀN TẤT!"
echo "Lưu ý: Bạn nên đăng xuất (Log out) hoặc khởi động lại máy để các thiết lập GNOME Extensions được áp dụng hoàn toàn."
echo "=========================================="
#!/bin/bash

# Dừng script ngay nếu có lệnh bị lỗi
set -e

# Lấy tên user hiện tại (để phân quyền KVM/libvirt chính xác)
REAL_USER=${SUDO_USER:-$USER}

echo "=========================================="
echo "1. Cập nhật hệ thống"
echo "=========================================="
sudo apt update && sudo apt upgrade -y

echo "=========================================="
echo "2. Cài đặt các gói cơ bản và GNOME Tools"
echo "=========================================="
sudo apt install -y curl wget gpg apt-transport-https software-properties-common htop gnome-tweaks gnome-shell-extensions gnome-shell-extension-manager

echo "=========================================="
echo "3. Cài đặt Git, GCC, G++ và Build Tools"
echo "=========================================="
sudo apt install -y git gcc g++ build-essential

echo "=========================================="
echo "4. Cài đặt KVM & Công cụ quản lý máy ảo (virt-manager)"
echo "=========================================="
# Cài đặt KVM, QEMU, libvirt và cpu-checker để kiểm tra KVM
sudo apt install -y qemu-kvm qemu-system-x86 libvirt-daemon-system libvirt-clients bridge-utils virt-manager cpu-checker

# Thêm user vào group kvm và libvirt để tạo/quản lý máy ảo không cần quyền root
sudo usermod -aG kvm,libvirt "$REAL_USER"
sudo systemctl enable --now libvirtd

echo "=========================================="
echo "5. Cài đặt Sublime Text"
echo "=========================================="
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list > /dev/null
sudo apt update
sudo apt install -y sublime-text

echo "=========================================="
echo "6. Cài đặt Visual Studio Code"
echo "=========================================="
curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg > /dev/null
echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
sudo apt update
sudo apt install -y code

echo "=========================================="
echo "7. Cài đặt Brave Browser"
echo "=========================================="
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null
sudo apt update
sudo apt install -y brave-browser

echo "=========================================="
echo "8. Cấu hình GNOME Dock (Minimize & Previews)"
echo "=========================================="
# Bấm vào icon: 1 cửa sổ -> Minimize/Restore, ≥2 cửa sổ -> Xem bản xem trước (Previews)
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'

echo "=========================================="
echo "CÀI ĐẶT HOÀN TẤT!"
echo "LƯU Ý QUAN TRỌNG:"
echo "1. Bạn NÊN ĐĂNG XUẤT (Log out) hoặc KHỞI ĐỘNG LẠI MÁY để nhóm quyền kvm/libvirt và các tiện ích GNOME hoạt động hoàn toàn."
echo "2. Sau khi khởi động lại, gõ 'kvm-ok' trong terminal để xác nhận KVM đã hoạt động."
echo "=========================================="

#!/bin/bash

# =========================================================================
# Script de Automação: Arch Linux + Caelestia Shell (Hyprland)
# =========================================================================

echo "🚀 Iniciando a configuração automática do ambiente..."

# 1. Otimizando o processador para compilação (AUR)
echo "⚙️  Otimizando makepkg para usar todos os núcleos do processador..."
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf

# 2. Ajustando Relógio e Fuso Horário
echo "🕒 Configurando fuso horário para America/Sao_Paulo..."
sudo timedatectl set-timezone America/Sao_Paulo
sudo timedatectl set-ntp true

# 3. Criando as pastas padrão de usuário (Downloads, Documentos, etc.)
echo "📁 Criando diretórios de usuário..."
sudo pacman -S --noconfirm xdg-user-dirs
xdg-user-dirs-update

# 4. Instalando Áudio, Codecs e Gerenciador de Arquivos (Dolphin)
echo "🎵 Instalando servidor de áudio, Dolphin e portais Wayland..."
sudo pacman -S --noconfirm pipewire pipewire-pulse pipewire-alsa wireplumber dolphin xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-kde

# 5. Configurando o Hyprland (Caelestia Shell)
echo "🎨 Configurando preferências do Caelestia (Monitor, Teclado e Mouse)..."
mkdir -p ~/.config/caelestia
touch ~/.config/caelestia/hypr-vars.conf

cat << 'EOF' > ~/.config/caelestia/hypr-user.conf
# Configuração de Monitor (Ajuste de Escala/Zoom para 125%)
monitor = , preferred, auto, 1.25

input {
    # Layout do teclado em Português do Brasil (ABNT2)
    kb_layout = br
    # Inversão do scroll do mouse
    natural_scroll = true
}

# Auto-iniciar o Wallpaper Engine (Requer configuração prévia na Steam)
# exec-once = linux-wallpaperengine --screen-root DP-1 --fps 60 --scaling stretch --bg-path ~/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/workshop/content/431960/NUMERO_AQUI
EOF

# 6. Configurando a "Cola" do Sistema (XDG Portals)
echo "🔗 Configurando integração do gerenciador de arquivos..."
mkdir -p ~/.config/xdg-desktop-portal
cat << 'EOF' > ~/.config/xdg-desktop-portal/portals.conf
[preferred]
default=hyprland;gtk
org.freedesktop.impl.portal.FileChooser=kde
EOF

# 7. Definindo Aplicativos Padrão
echo "🌐 Definindo Dolphin como padrão..."
xdg-mime default org.kde.dolphin.desktop inode/directory

echo "🛠️ Aplicando permissões para Flatpaks conversarem com o Dolphin..."
# Nota: O Zen Browser precisa ser instalado via Flatpak antes.
# flatpak install flathub app.zen_browser.zen -y
sudo flatpak override --talk-name=org.freedesktop.FileManager1 app.zen_browser.zen 2>/dev/null

echo "✅ Configuração concluída com sucesso! É recomendado reiniciar o sistema."

#!/bin/bash

# Definir colores para salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # Sin color

echo -e "${BLUE}################################################################"
echo -e "${BLUE}SCRIPT DE INSTALACION DE ESCRITORIO DE ARCH 2025"
echo -e "${BLUE}################################################################${NC}"

# Actualizar el sistema
echo -e "${YELLOW}Actualizando el sistema...${NC}"
sudo pacman -Syuu --noconfirm
clear

# Instalar MATE y otros complementos básicos
echo -e "${YELLOW}Instalando Escritorio MATE y complementos...${NC}"
if ! pacman -Qi mate &>/dev/null; then
  sudo pacman -S --noconfirm mate mate-extra
else
  echo -e "${GREEN}MATE ya está instalado.${NC}"
fi

# Instalar NetworkManager y otros servicios
if ! pacman -Qi networkmanager &>/dev/null; then
  sudo pacman -S --noconfirm networkmanager wpa_supplicant git ly plank
else
  echo -e "${GREEN}NetworkManager ya está instalado.${NC}"
fi

# Habilitar el gestor de login Ly
sudo systemctl enable ly.service

clear
echo -e "${YELLOW}Instalando drivers gráficos...${NC}"

# Detectar el tipo de tarjeta gráfica
GPU=$(lspci | grep -i VGA)

echo -e "${YELLOW}Detectando la tarjeta gráfica...${NC}"

if [[ "$GPU" == *"NVIDIA"* ]]; then
  # Si es una tarjeta Nvidia
  echo -e "${GREEN}Tarjeta Nvidia detectada.${NC}"
  if ! pacman -Qi nvidia &>/dev/null; then
    sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings opencl-nvidia
  else
    echo -e "${GREEN}Nvidia Drivers ya están instalados.${NC}"
  fi
elif [[ "$GPU" == *"Intel"* ]]; then
  # Si es una tarjeta Intel (iGPU)
  echo -e "${GREEN}Tarjeta Intel detectada.${NC}"
  if ! pacman -Qi xf86-video-intel &>/dev/null; then
    sudo pacman -S --noconfirm xf86-video-intel
  else
    echo -e "${GREEN}Intel Drivers ya están instalados.${NC}"
  fi
elif [[ "$GPU" == *"AMD"* ]]; then
  # Si es una tarjeta AMD
  echo -e "${GREEN}Tarjeta AMD detectada.${NC}"
  if ! pacman -Qi xf86-video-amdgpu &>/dev/null; then
    sudo pacman -S --noconfirm xf86-video-amdgpu
  else
    echo -e "${GREEN}AMD Drivers ya están instalados.${NC}"
  fi
else
  echo -e "${RED}No se pudo detectar una tarjeta gráfica compatible.${NC}"
fi

# Instalar fuentes y otros programas esenciales
echo -e "${YELLOW}Instalando fuentes y aplicaciones básicas...${NC}"
sudo pacman -S --noconfirm libreoffice openshot discord htop \
  ttf-fira-code ttf-jetbrains-mono ttf-dejavu noto-fonts

# Crear directorios de usuario si no existen
xdg-user-dirs-update
mkdir -p ~/Documentos ~/Descargas ~/Música ~/Videos ~/Imágenes ~/Escritorio

# Instalación de GRUB Theme
echo -e "${YELLOW}Instalando tema para GRUB...${NC}"
if ! pacman -Qi grub &>/dev/null; then
  git clone https://github.com/vinceliuice/grub2-themes.git
  cd grub2-themes/
  sudo ./install.sh
  cd ..
else
  echo -e "${GREEN}GRUB ya está instalado.${NC}"
fi

# Instalación de OBS Studio (si no está instalado)
echo -e "${YELLOW}Instalando OBS Studio...${NC}"
if ! pacman -Qi obs-studio &>/dev/null; then
  sudo pacman -S --noconfirm obs-studio
else
  echo -e "${GREEN}OBS Studio ya está instalado.${NC}"
fi

# Instalación de VLC
echo -e "${YELLOW}Instalando VLC...${NC}"
if ! pacman -Qi vlc &>/dev/null; then
  sudo pacman -S --noconfirm vlc
else
  echo -e "${GREEN}VLC ya está instalado.${NC}"
fi

# Instalación de Steam (si se desea jugar)
echo -e "${YELLOW}¿Quieres instalar Steam? (y/n): ${NC}"
read -r answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
  echo -e "${YELLOW}Instalando Steam...${NC}"
  if ! pacman -Qi steam &>/dev/null; then
    sudo pacman -S --noconfirm steam
  else
    echo -e "${GREEN}Steam ya está instalado.${NC}"
  fi
fi

# Instalación de Wine (para juegos y aplicaciones de Windows)
echo -e "${YELLOW}¿Quieres instalar Wine? (y/n): ${NC}"
read -r answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
  echo -e "${YELLOW}Instalando Wine...${NC}"
  if ! pacman -Qi wine &>/dev/null; then
    sudo pacman -S --noconfirm wine wine-gecko wine-mono
  else
    echo -e "${GREEN}Wine ya está instalado.${NC}"
  fi
fi

# Instalación de iconos y temas
echo -e "${YELLOW}Instalando iconos y temas desde archivos TAR.XZ...${NC}"

# Extraer iconos desde el mismo directorio
if [ -f "./icons.tar.xz" ]; then
  echo -e "${YELLOW}Extrayendo iconos...${NC}"
  tar -xf "./icons.tar.xz" -C "$HOME/.icons" --strip-components=1
else
  echo -e "${RED}No se encontró el archivo icons.tar.xz en el directorio actual.${NC}"
fi

# Extraer tema desde el mismo directorio
if [ -f "./tema.tar.xz" ]; then
  echo -e "${YELLOW}Extrayendo tema...${NC}"
  tar -xf "./tema.tar.xz" -C "$HOME/.themes" --strip-components=1
else
  echo -e "${RED}No se encontró el archivo tema.tar.xz en el directorio actual.${NC}"
fi

# Verificar instalación de los paquetes
echo -e "${BLUE}################################################################"
echo -e "${BLUE}VERIFICANDO INSTALACIONES...${NC}"

# Mostrar el estado de instalación
echo -e "${GREEN}Paquetes instalados:${NC}"
pacman -Qi mate networkmanager obs-studio vlc steam wine

clear
echo -e "${GREEN}Instalación completada exitosamente. ¡Listo para usar!${NC}"

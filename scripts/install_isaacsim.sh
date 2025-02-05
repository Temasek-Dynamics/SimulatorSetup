#!/bin/bash

set -e

TARGET_DIR="submodules"
OMNIVERSE_LAUNCHER="$TARGET_DIR/omniverse-launcher-linux.AppImage"
echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m✅ [INFO] Setting up Omniverse Launcher...\e[0m"
echo -e "\e[1;32m=============================================\e[0m"

# Download Omniverse Launcher
if [ ! -f "$OMNIVERSE_LAUNCHER" ]; then
    echo -e "\e[1;34m🔄 [INFO] Downloading Omniverse Launcher...\e[0m"
    wget -O "$OMNIVERSE_LAUNCHER" https://install.launcher.omniverse.nvidia.com/installers/omniverse-launcher-linux.AppImage
    chmod +x "$OMNIVERSE_LAUNCHER"
    echo -e "\e[1;32m✅ [INFO] Omniverse Launcher downloaded and made executable at $OMNIVERSE_LAUNCHER\e[0m"
else
    echo -e "\e[1;32m✅ [INFO] Omniverse Launcher already exists at $OMNIVERSE_LAUNCHER, skipping download.\e[0m"
fi

# Install Isaac sim 4.2.0 using the omniverse launcher GUI next.
echo -e "\e[1;36m🚀 [INFO] Please run the Omniverse Launcher GUI and install Isaac Sim 4.2.0 manually.\e[0m"

# The next part is left for Isaacsim_python package install.
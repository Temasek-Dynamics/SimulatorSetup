#!/bin/bash

set -e

ISAACSIM_PATH="${HOME}/.local/share/ov/pkg/isaac-sim-4.2.0/"
mkdir -p "$ISAACSIM_PATH"
ISAACSIM="$ISAACSIM_PATH/isaac-sim.sh"
URL="https://download.isaacsim.omniverse.nvidia.com/isaac-sim-standalone%404.2.0-rc.18%2Brelease.16044.3b2ed111.gl.linux-x86_64.release.zip"

# Define the zip file name
ISAACSIM_ZIP="$ISAACSIM_PATH/isaac-sim.zip"

echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m✅ [INFO] Setting up Isaac Sim...\e[0m"
echo -e "\e[1;32m=============================================\e[0m"

# Download Isaac Sim
if [ ! -f "$ISAACSIM" ]; then
    echo -e "\e[1;34m🔄 [INFO] Downloading Isaac Sim...\e[0m"
    wget -O $ISAACSIM_ZIP $URL
    unzip $ISAACSIM_ZIP -d $ISAACSIM_PATH
    chmod +x $ISAACSIM
    echo -e "\e[1;32m✅ [INFO] Isaac Sim downloaded and made executable at $ISAACSIM_PATH\e[0m"
else
    echo -e "\e[1;32m✅ [INFO] Isaac Sim already exists at $ISAACSIM_PATH, skipping download.\e[0m"
fi

# Install Isaac Sim 4.2.0 using the Omniverse Launcher GUI next.
echo -e "\e[1;36m🚀 [INFO] Isaac Sim 4.2.0 has been successfully installed.\e[0m"

# The next part is left for Isaacsim_python package install.

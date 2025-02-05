#!/bin/bash

set -e

# Echo starting message
echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m🛠️ [INFO] Setting up simulation environment...\e[0m"
echo -e "\e[1;32m=============================================\e[0m"

# Set configuration file
FILE_NAME="ubuntu22.04.yaml"
SCRIPT_DIR=$(dirname "$0")
CONFIG_FILE=$(realpath $SCRIPT_DIR/configs/$FILE_NAME)
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "\e[1;31m❌ [ERROR] $CONFIG_FILE does not exist!\e[0m" 1>&2
    return 0
else
    echo -e "\e[1;32m✅ [INFO] Using config: $CONFIG_FILE\e[0m"
fi

# Run the installation scripts
bash scripts/install_common.sh
bash scripts/install_ros2.sh
export CONFIG_FILE=$(realpath "$CONFIG_FILE")
bash scripts/install_isaacsim.sh
bash scripts/install_pegasus.sh
bash scripts/install_px4.sh

# Echo ending message
echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m✅ [INFO] Setup complete! 🚀\e[0m"
echo -e "\e[1;32m=============================================\e[0m"
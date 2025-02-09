#!/bin/bash
set -e

# Parse arguments
RUN_DEMO=true
if [[ "$1" == "--no-demo" ]]; then
    RUN_DEMO=false
fi

# Echo starting message
echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m🛠️ [INFO] Setting up simulation environment...\e[0m"
echo -e "\e[1;32m=============================================\e[0m"

# Set configuration file
FILE_NAME="ubuntu22.04.yaml"
export SETUP_DIR=$(realpath "$(dirname "$0")")
export SCRIPT_DIR=$(realpath $SETUP_DIR/scripts)
export CONFIG_FILE=$(realpath $SETUP_DIR/configs/$FILE_NAME)
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "\e[1;31m❌ [ERROR] $CONFIG_FILE does not exist!\e[0m" 1>&2
    return 0
else
    echo -e "\e[1;32m✅ [INFO] Using config: $CONFIG_FILE\e[0m"
fi

# Run the installation scripts
bash $SCRIPT_DIR/install_common.sh
bash $SCRIPT_DIR/install_ros2.sh
bash $SCRIPT_DIR/install_isaacsim.sh
bash $SCRIPT_DIR/install_px4.sh
bash $SCRIPT_DIR/install_pegasus.sh

# Run the demo script
if [ "$RUN_DEMO" = true ]; then
    bash $SCRIPT_DIR/demo.sh
fi

# Echo ending message
echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m✅ [INFO] Setup complete! 🚀\e[0m"
echo -e "\e[1;32m=============================================\e[0m"
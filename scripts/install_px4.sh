#!/bin/bash
set -e

# Configuration file name
MODULE_NAME="PX4-Autopilot"

# Echo starting message
echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m✅ [INFO] Installing $MODULE_NAME...\e[0m"
echo -e "\e[1;32m=============================================\e[0m"

# Install yq for parsing YAML files
if ! command -v yq &>/dev/null; then
    sudo apt update
    sudo snap install yq
fi

# Get PX4 repository URL and branch
URL=$(yq e ".github_repos[] | select(.name == \"$MODULE_NAME\") | .url" $CONFIG_FILE)
BRANCH=$(yq e ".github_repos[] | select(.name == \"$MODULE_NAME\") | .branch" $CONFIG_FILE)
MODULE_DIR=$SETUP_DIR/$(yq e ".github_repos[] | select(.name == \"$MODULE_NAME\") | .path" $CONFIG_FILE)
echo -e "\e[1;32m🔗 [INFO] URL: $URL\e[0m"
echo -e "\e[1;32m🌿 [INFO] Branch: $BRANCH\e[0m"
echo -e "\e[1;32m📂 [INFO] Path: $MODULE_DIR\e[0m"

# Clone PX4 repository
if ! [ -d "$MODULE_DIR" ]; then
    git clone -b "$BRANCH" "$URL" "$MODULE_DIR" --recursive
else
    echo -e "\e[1;33m⚠️ [WARNING] $MODULE_NAME already exists! Skipping clone...\e[0m"
fi

# Set up PX4 environment (Without simulation tools)
bash $MODULE_DIR/Tools/setup/ubuntu.sh --no-sim-tools

# Build PX4 in PX4-Autopilot directory
make -C $MODULE_DIR DONT_RUN=1 px4_sitl_default none

# Install QGroundControl
echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m✅ [INFO] Installing QGroundControl...\e[0m"
echo -e "\e[1;32m=============================================\e[0m"
QGC_NAME="QGroundControl-x86_64.AppImage"
QGC_DIR="$SETUP_DIR/submodules/QGroundControl"

# Skip download if QGroundControl already exists
if [ -f "$QGC_DIR/$QGC_NAME" ]; then
    echo -e "\e[1;33m⚠️ [WARNING] $QGC_NAME already exists! Skipping download...\e[0m"
else
    wget https://github.com/mavlink/qgroundcontrol/releases/download/v3.5.6/QGroundControl.AppImage -P $QGC_DIR
fi

# Echo ending message
echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m🎉 [INFO] $MODULE_NAME Installed Successfully! 🚀\e[0m"
echo -e "\e[1;32m=============================================\e[0m"

#!/bin/bash
trap 'echo -e "\e[1;31m❌ [ERROR] Command failed: $BASH_COMMAND at line $LINENO\e[0m"' ERR
set -e

# Echo starting message
echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m✅ [INFO] Starting System & Python Package Installation...\e[0m"
echo -e "\e[1;32m=============================================\e[0m"

# Ensure the YAML configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "\e[1;31m❌ [ERROR] CONFIG_FILE is not provided. Please run setup.sh to set CONFIG_FILE.\e[0m"
    exit 1
fi
CONFIG_FILE=$(realpath "$CONFIG_FILE")
echo -e "\e[1;36m📄 [INFO] Using configuration file: $CONFIG_FILE\e[0m"

# Ensure yq is installed
if ! command -v yq &> /dev/null; then
    echo -e "\e[1;33m🔹 [INFO] 'yq' not found. Installing via snap...\e[0m"
    sudo snap install yq
fi

# ================================
# Install System Packages
# ================================

echo -e "\e[1;36m=============================================\e[0m"
echo -e "\e[1;36m🛠️ [INFO] Updating package lists (apt)...\e[0m"
echo -e "\e[1;36m=============================================\e[0m"

sudo apt update -y

echo -e "\e[1;36m=============================================\e[0m"
echo -e "\e[1;36m🛠️ [INFO] Checking and Installing System Packages\e[0m"
echo -e "\e[1;36m=============================================\e[0m"

SYSTEM_PACKAGES_INSTALLED=0
SYSTEM_PACKAGES_SKIPPED=0

# Parse system_packages，ensure yq success
SYSTEM_PACKAGES=$(yq e '.system_packages[]' "$CONFIG_FILE" 2>/dev/null) || {
    echo -e "\e[1;31m❌ [ERROR] Failed to parse 'system_packages' from YAML file!\e[0m"
    exit 1
}

if [ -z "$SYSTEM_PACKAGES" ]; then
    echo -e "\e[1;33m⚠️ [WARNING] No system packages found in YAML file. Skipping installation.\e[0m"
    exit 0
fi

# install system_packages
while read package; do
    if dpkg -l | grep -q "^ii  $package "; then
        echo -e "\e[1;34m📦 [INFO] System package '$package' is already installed. Skipping...\e[0m"
        SYSTEM_PACKAGES_SKIPPED=$(expr $SYSTEM_PACKAGES_SKIPPED + 1)
    else
        echo -e "\e[1;33m🔹 [INFO] Installing system package '$package'...\e[0m"
        sudo apt install -y "$package"
        SYSTEM_PACKAGES_INSTALLED=$(expr $SYSTEM_PACKAGES_INSTALLED + 1)
    fi
done < <(echo "$SYSTEM_PACKAGES")

echo -e "\e[1;32m✅ [INFO] System Packages Installed: $SYSTEM_PACKAGES_INSTALLED, Skipped: $SYSTEM_PACKAGES_SKIPPED\e[0m"

# ================================
# Install Python Packages
# ================================

# Use the system's default Python
PYTHON_CMD="python3"
PIP_CMD="$PYTHON_CMD -m pip"

# Ensure Python is installed
if ! command -v $PYTHON_CMD &> /dev/null; then
    echo -e "\e[1;31m❌ [ERROR] Python3 is not installed! Please install it first.\e[0m"
    exit 1
fi

# Ensure pip is installed
if ! command -v pip3 &> /dev/null || ! pip3 list &> /dev/null; then
    echo -e "\e[1;33m🔹 [INFO] 'pip' not found or broken. Installing...\e[0m"
    sudo apt update -y
    sudo apt install -y python3-pip
else
    echo -e "\e[1;34m📦 [INFO] 'pip' is already installed. Skipping...\e[0m"
fi

# Upgrade pip
echo -e "\e[1;32m✅ [INFO] Upgrading pip...\e[0m"
$PIP_CMD install --upgrade pip setuptools wheel

# Check and Install Python Packages
echo -e "\e[1;35m=============================================\e[0m"
echo -e "\e[1;35m🐍 [INFO] Checking and Installing Python Packages\e[0m"
echo -e "\e[1;35m=============================================\e[0m"

PYTHON_PACKAGES_INSTALLED=0
PYTHON_PACKAGES_SKIPPED=0

# Ensure yq executes successfully and fetch package list
PYTHON_PACKAGES=$(yq e '.python_packages[]' "$CONFIG_FILE" 2>/dev/null) || {
    echo -e "\e[1;31m❌ [ERROR] Failed to parse 'python_packages' from YAML file!\e[0m"
    exit 1
}

# Check if PYTHON_PACKAGES is empty
if [ -z "$PYTHON_PACKAGES" ]; then
    echo -e "\e[1;33m⚠️ [WARNING] No Python packages found in YAML file. Skipping installation.\e[0m"
    exit 0
fi

# Debugging output
# echo -e "\e[1;36m[CONFIG] Python packages list:\n$PYTHON_PACKAGES\e[0m"

while read package; do
    PACKAGE_NAME=$(echo "$package" | cut -d= -f1)
    if $PIP_CMD show "$PACKAGE_NAME" &> /dev/null; then
        echo -e "\e[1;34m📦 [INFO] Python package '$package' is already installed. Skipping...\e[0m"
        PYTHON_PACKAGES_SKIPPED=$(expr $PYTHON_PACKAGES_SKIPPED + 1)
    else
        echo -e "\e[1;33m🔹 [INFO] Installing Python package '$package'...\e[0m"
        $PIP_CMD install "$package"
        PYTHON_PACKAGES_INSTALLED=$(expr $PYTHON_PACKAGES_INSTALLED + 1)
    fi
done < <(echo "$PYTHON_PACKAGES")

echo -e "\e[1;32m✅ [INFO] Python Packages Installed: $PYTHON_PACKAGES_INSTALLED, Skipped: $PYTHON_PACKAGES_SKIPPED\e[0m"

# Verify installation
echo -e "\e[1;32m✅ [INFO] Python version: $($PYTHON_CMD --version)\e[0m"
echo -e "\e[1;32m✅ [INFO] pip version: $($PIP_CMD --version)\e[0m"

# Echo ending message
echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m🎉 [INFO] System & Python Packages Installed Successfully! 🚀\e[0m"
echo -e "\e[1;32m=============================================\e[0m"

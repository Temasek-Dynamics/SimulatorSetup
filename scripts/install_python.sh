#!/bin/bash

# Exit immediately if any command fails
set -e

# Check if a YAML configuration file path is provided
if [ -z "$1" ]; then
    echo "Error: No YAML configuration file specified!"
    echo "Usage: $0 <path_to_yaml_config>"
    exit 1
fi

CONFIG_FILE="$1"

# Ensure the YAML configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: YAML configuration file '$CONFIG_FILE' not found!"
    exit 1
fi

# Check if yq is installed, install it using snap if not found
if ! command -v yq &> /dev/null; then
    echo "yq is not installed. Installing yq via snap..."
    sudo snap install yq
fi

# Use the system's default Python
PYTHON_CMD="python3"
PIP_CMD="$PYTHON_CMD -m pip"

# Ensure Python is installed
if ! command -v $PYTHON_CMD &> /dev/null; then
    echo "Error: Python3 is not installed! Please install it first."
    exit 1
fi

# Ensure pip is installed
if ! $PYTHON_CMD -m ensurepip &> /dev/null; then
    echo "pip is not installed. Installing pip..."
    sudo apt update -y
    sudo apt install -y python3-pip
fi

# Upgrade pip
echo "Upgrading pip..."
$PIP_CMD install --upgrade pip setuptools wheel

# Read the python_packages list from YAML and install them
echo "Installing Python packages from $CONFIG_FILE..."
yq e '.python_packages[] | .name + "==" + .version' "$CONFIG_FILE" | while read package; do
    echo "Installing $package..."
    $PIP_CMD install "$package"
done

# Verify installation
echo "Python version: $($PYTHON_CMD --version)"
echo "pip version: $($PIP_CMD --version)"

echo "Installation completed!"


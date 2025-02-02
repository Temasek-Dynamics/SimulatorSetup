#!/bin/bash
set -e

# CONFIG_FILE=${CONFIG_FILE:-"configs/ubuntu22.04.yaml"}

# echo "[INFO] Installing system packages..."
# sudo apt update
# for package in $(yq e '.system_packages[]' "$CONFIG_FILE"); do
#     sudo apt install -y "$package"
# done

# echo "[INFO] Installing Python packages..."
# for package in $(yq e '.python_packages[]' "$CONFIG_FILE"); do
#     pip install "$package"
# done

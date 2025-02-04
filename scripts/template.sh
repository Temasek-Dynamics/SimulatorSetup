#!/bin/bash
set -e

# Echo starting message
echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m✅ [INFO] Installing XXX...\e[0m"
echo -e "\e[1;32m=============================================\e[0m"

# TODO: Your installation script goes here
echo -e "\e[1;32m✅ [INFO] Some general infomation.\e[0m"
echo -e "\e[1;33m⚠️ [WARNING] Some harmless warning.\e[0m"
echo -e "\e[1;31m❌ [ERROR] Some harmful warning.\e[0m" 1>&2

# Echo ending message
echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m🎉 [INFO] XXX Installed Successfully! 🚀\e[0m"
echo -e "\e[1;32m=============================================\e[0m"

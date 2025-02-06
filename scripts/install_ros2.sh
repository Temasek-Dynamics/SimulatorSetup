#!/bin/bash
set -e

# Set the ROS 2 version
ROS2_VERSION="humble"

# Echo starting message
echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m✅ [INFO] Installing ROS 2 $ROS2_VERSION...\e[0m"
echo -e "\e[1;32m=============================================\e[0m"

# Set the locale for UTF-8
sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# Ensure the Ubuntu Universe repository is enabled
sudo apt install software-properties-common
sudo add-apt-repository universe -y

# Add the ROS 2 GPG key
sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS 2
sudo apt update && sudo apt upgrade -y
sudo apt install ros-humble-desktop ros-dev-tools -y

# Detect the default shell and add sourcing to the appropriate configuration file
DEFAULT_SHELL=$(basename "$SHELL")
RC_FILE="$HOME/.${DEFAULT_SHELL}rc"
SOURCE_LINE="source /opt/ros/$ROS2_VERSION/setup.${DEFAULT_SHELL}"

# Check if the lines already exist before adding them
if ! grep -Fxq "$SOURCE_LINE" "$RC_FILE"; then
    echo "" >> "$RC_FILE" # Add a newline before appending the source line
    echo "# Source ROS 2" >> "$RC_FILE" # Add a comment before appending the source line
    echo "$SOURCE_LINE" >> "$RC_FILE"
    eval "$SOURCE_LINE" # Source the line in the current shell
fi

# Echo ending message
echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m🎉 [INFO] ROS 2 $ROS2_VERSION Installed Successfully! 🚀\e[0m"
echo -e "\e[1;32m=============================================\e[0m"

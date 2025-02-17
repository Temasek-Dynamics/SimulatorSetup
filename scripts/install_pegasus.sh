#!/bin/bash

set -e

echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m✅ [INFO] Setting up Isaac Sim Environment...\e[0m"
echo -e "\e[1;32m=============================================\e[0m"

if [ -z "$CONFIG_FILE" ]; then
    echo -e "\e[1;31m❌ [ERROR] CONFIG_FILE is not provided. Please run setup.sh to set CONFIG_FILE.\e[0m"
    exit 1
fi

CONFIG_FILE=$(realpath "$CONFIG_FILE")
echo -e "\e[1;36m📄 [INFO] Using configuration file: $CONFIG_FILE\e[0m"


# Export the Isaac sim path to system PATH (default path installed using omniverse GUI)
# Define the environment variables
ISAACSIM_PATH="${HOME}/.local/share/ov/pkg/isaac-sim-4.2.0"

DEFAULT_SHELL=$(basename "$SHELL")
SHELL_FILE="$HOME/.${DEFAULT_SHELL}rc"
echo -e "\e[1;34m⚙️  [INFO] Using shell configuration file: $SHELL_FILE\e[0m"
echo -e "\e[1;33m🔧 [INFO] Configuring environment variables...\e[0m"

# Append to the user's config
if ! grep -Fq "export ISAACSIM_PATH=" "$SHELL_FILE"; then
  echo "export ISAACSIM_PATH=\"$ISAACSIM_PATH\"" >> "$SHELL_FILE"
  echo "Added export ISAACSIM_PATH to $SHELL_FILE"
else
  echo "export ISAACSIM_PATH already exists in $SHELL_FILE"
fi

if ! grep -Fq "alias ISAACSIM_PYTHON=" "$SHELL_FILE"; then
  echo "alias ISAACSIM_PYTHON=\"\$ISAACSIM_PATH/python.sh\"" >> "$SHELL_FILE"
  echo "Added alias ISAACSIM_PYTHON to $SHELL_FILE"
else
  echo "alias ISAACSIM_PYTHON already exists in $SHELL_FILE"
fi

if ! grep -Fq "alias ISAACSIM=" "$SHELL_FILE"; then
  echo "alias ISAACSIM=\"\$ISAACSIM_PATH/isaac-sim.sh\"" >> "$SHELL_FILE"
  echo "Added alias ISAACSIM to $SHELL_FILE"
else
  echo "alias ISAACSIM already exists in $SHELL_FILE"
fi

# Install PegasusSimulator
PEGASUS_URL=$(yq e '.github_repos[] | select(.name == "pegasus") | .url' "$CONFIG_FILE")
PEGASUS_BRANCH=$(yq e '.github_repos[] | select(.name == "pegasus") | .branch' "$CONFIG_FILE")
PEGASUS_PATH=$SETUP_DIR/$(yq e '.github_repos[] | select(.name == "pegasus") | .path' "$CONFIG_FILE")
PEGASUS_EXTENSION_PATH="$PEGASUS_PATH/extensions"

if [ ! -d "$PEGASUS_PATH/.git" ]; then
    echo -e "\e[1;34m🔄 [INFO] Cloning Pegasus Simulator repository from $PEGASUS_URL...\e[0m"
    git clone --branch "$PEGASUS_BRANCH" "$PEGASUS_URL" "$PEGASUS_PATH"
    echo -e "\e[1;32m✅ [INFO] Pegasus Simulator cloned successfully.\e[0m"
else
    echo -e "\e[1;33m⚠️  [INFO] Pegasus repository already exists. Pulling latest changes...\e[0m"
    git -C "$PEGASUS_PATH" pull origin "$PEGASUS_BRANCH"
    echo -e "\e[1;32m✅ [INFO] Pegasus repository updated.\e[0m"
fi

echo -e "\e[1;34m🔧 [INFO] Installing Pegasus Simulator Python package...\e[0m"
"$ISAACSIM_PATH/python.sh" -m pip install --editable "$PEGASUS_EXTENSION_PATH/pegasus.simulator"
echo -e "\e[1;32m✅ [INFO] Pegasus Simulator installed successfully.\e[0m"

echo -e "\e[1;34m🔧 [INFO] Setting PX4 path...\e[0m"
PEGASUS_CONFIG="$PEGASUS_PATH/extensions/pegasus.simulator/config/configs.yaml"
PX4_RELATIVE_DIR=$(yq e '.github_repos[] | select(.name == "PX4-Autopilot") | .path' "$CONFIG_FILE")
PX4_DIR=$(realpath "$SETUP_DIR/$PX4_RELATIVE_DIR")
yq eval ".px4_dir = \"$PX4_DIR\"" -i "$PEGASUS_CONFIG"
echo -e "\e[1;32m✅ [INFO] PX4 path set successfully.\e[0m"

echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m🎉 [INFO] Pegasus Simulator Setup Completed! 🚀\e[0m"
echo -e "\e[1;32m=============================================\e[0m"

#!/bin/bash

set -e
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
CONFIG_FILE="$(realpath configs/ubuntu22.04.yaml)"
echo "CONFIG_FILE is set to: $CONFIG_FILE"

# Export the Isaac sim path to system PATH (default path installed using omniverse GUI)
# Define the environment variables
ISAACSIM_PATH="${HOME}/.local/share/ov/pkg/isaac-sim-4.2.0"


# Append to the user's bash config
echo "export ISAACSIM_PATH=\"$ISAACSIM_PATH\"" >> ~/.bashrc
echo "alias ISAACSIM_PYTHON=\"\$ISAACSIM_PATH/python.sh\"" >> ~/.bashrc
echo "alias ISAACSIM=\"\$ISAACSIM_PATH/isaac-sim.sh\"" >> ~/.bashrc


# Append to the user's zsh config
echo "export ISAACSIM_PATH=\"$ISAACSIM_PATH\"" >> ~/.zshrc
echo "alias ISAACSIM_PYTHON=\"\$ISAACSIM_PATH/python.sh\"" >> ~/.zshrc
echo "alias ISAACSIM=\"\$ISAACSIM_PATH/isaac-sim.sh\"" >> ~/.zshrc


# Source env to make the new variables work
source ~/.bashrc
source ~/.zshrc


# Install PegasusSimulator
PEGASUS_URL=$(yq e '.github_repos[] | select(.name == "pegasus") | .url' "$CONFIG_FILE")
PEGASUS_BRANCH=$(yq e '.github_repos[] | select(.name == "pegasus") | .branch' "$CONFIG_FILE")
PEGASUS_PATH=$(yq e '.github_repos[] | select(.name == "pegasus") | .path' "$CONFIG_FILE")
PEGASUS_EXTENSION_PATH=$PEGASUS_PATH/extensions
# Clone repo
if [ ! -d "$PEGASUS_PATH/.git" ]; then
    echo "[INFO] Cloning Pegasus Simulator repository..."
    git clone --branch "$PEGASUS_BRANCH" "$PEGASUS_URL" "$PEGASUS_PATH"
else
    echo "[INFO] Pegasus repository already exists. Pulling latest changes..."
    cd "$PEGASUS_PATH"
    git pull origin "$PEGASUS_BRANCH"
fi


# Run the pip command using the built-in python interpreter
"$ISAACSIM_PATH/python.sh" -m pip install --editable $PEGASUS_EXTENSION_PATH/pegasus.simulator




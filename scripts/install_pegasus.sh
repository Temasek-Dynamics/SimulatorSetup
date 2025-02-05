#!/bin/bash

set -e
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

# Avoid hard-code
if [ -z "$CONFIG_FILE" ]; then
  echo "Error: CONFIG_FILE is not provided. Please run setup.sh to set CONFIG_FILE."
  exit 1
fi
CONFIG_FILE=$(realpath "$CONFIG_FILE")
echo "CONFIG_FILE is set to: $CONFIG_FILE"


# Export the Isaac sim path to system PATH (default path installed using omniverse GUI)
# Define the environment variables
ISAACSIM_PATH="${HOME}/.local/share/ov/pkg/isaac-sim-4.2.0"

DEFAULT_SHELL=$(basename "$SHELL")
SHELL_FILE="$HOME/.${DEFAULT_SHELL}rc"
echo "Using shell config file: $SHELL_FILE"

# Append to the user's bash config
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


# Source env to make the new variables work
source $SHELL_FILE


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




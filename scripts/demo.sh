#!/bin/bash
set -e

# Echo starting message
echo -e "\e[1;32m=============================================\e[0m"
echo -e "\e[1;32m🛠️ [INFO] Starting a take-off demo...\e[0m"
echo -e "\e[1;32m=============================================\e[0m"

# Commands
PEGASUS_CMD="ISAACSIM_PYTHON $SETUP_DIR/submodules/PegasusSimulator/examples/1_px4_single_raynor.py"
QGC_CMD="$SETUP_DIR/submodules/QGroundControl/QGroundControl.AppImage"

# Install tmux
sudo apt update
sudo apt install tmux -y

# Create a new tmux session
SESSION_NAME="demo"
tmux kill-session -t $SESSION_NAME 2>/dev/null || true
tmux new-session -d -s $SESSION_NAME
tmux split-window -h
tmux send-keys -t $SESSION_NAME:0.0 "$PEGASUS_CMD" C-m
tmux send-keys -t $SESSION_NAME:0.1 "$QGC_CMD" C-m
tmux attach -t $SESSION_NAME

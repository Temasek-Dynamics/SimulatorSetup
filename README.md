# **Simulator Setup**
Scripts for fast and automated installation of simulation environments.

## **Quick Setup**
To set up the full simulation environment, including PX4, ROS2 Humble, and related dependencies, simply run:
```bash
bash setup.sh
```
This will automatically install system dependencies, clone required repositories, and configure the simulation environment.

For additional customization, you can modify the configuration files located in the `configs/` directory.

## **Isaac Sim Installation**
[Isaac Sim 4.2.0](https://docs.omniverse.nvidia.com/isaacsim/latest/release_notes.html#) is recommedned for the simulator. For a workstation installation with GUI support, it is recommended to install Isaac Sim using the Omniverse Launcher.  

To install Omniverse Launcher, run:
```bash
bash scripts/install_isaacsim.sh
```
For detailed steps on GUI-based installation of Isaac Sim, refer to the official [Workstation Installation Guide](https://docs.omniverse.nvidia.com/isaacsim/latest/installation/install_workstation.html) provided by NVIDIA.

## **Pegasus Simulator Installation**
Pegasus Simulator can be installed by running:
```bash
bash scripts/install_pegasus.sh
```
The installation of Pegasus Simulator is based on the GUI-installed Isaac Sim, assuming it is located in the default installation path (`$HOME/.local/share/ov/pkg/isaac-sim-4.2.0`).

During installation, the script will:
1. Set up environment variables for Isaac Sim.
2. Clone the Pegasus Simulator repository if it is not already present.
3. Pull the latest changes if the repository exists.
4. Install the Pegasus Simulator extension using the built-in Isaac Sim Python interpreter.

Ensure you have the necessary dependencies installed before running the script. If needed, modify the `configs/ubuntu22.04.yaml` file to customize repository settings and installation paths.

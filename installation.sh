#!/bin/bash
########################
## Please make sure that bin/bash is the location of your bash terminal, if not please replace with your local machine's bash path
## Installation script for cortex.
## This script is created to be downloaded indenendently and used
## like this: curl -o- -L https://raw.githubusercontent.com/robocomp/cortex/development/installation.sh | bash -x
## This will install all the cortex dependencies and the library itself. You can read this script and dependencies.sh to better know what is done.
#######################
branch="${1:-development}"
ROS_DISTRO="humble"
set -e
git clone --branch $branch https://github.com/grupo-avispa/cortex.git
cd cortex
yes | bash dependencies.sh
if [ -d "/opt/ros/${ROS_DISTRO}" ]; then
  source /opt/ros/${ROS_DISTRO}/setup.bash
fi
mkdir -p build
cd build
cmake ..
make -j$(nproc --ignore=1)
sudo make install
sudo ldconfig
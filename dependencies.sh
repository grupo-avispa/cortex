#!/bin/bash 
# Please make sure that bin/bash is the location of your bash terminal,if not please replace with your local machine's bash path
branch="${1:-development}"
ROS_DISTRO="jazzy"
echo "Installing dependencies for branch $branch"
sudo DEBIAN_FRONTEND=noninteractive apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    git \
    libasio-dev \
    libeigen3-dev \
    libopencv-dev \
    libopenscenegraph-dev \
    libqglviewer-dev-qt5 \
    libtinyxml2-dev \
    python3-dev \
    python3-pybind11 \
    qtbase5-dev \

echo "Installing third-party software cppitertools"
sudo git clone https://github.com/ryanhaining/cppitertools /usr/local/include/cppitertools
cd /usr/local/include/cppitertools
sudo mkdir -p build && cd build
sudo cmake .. && sudo make install

echo "Installing third-party software Fast-RTPS"
if [ -d "/opt/ros/${ROS_DISTRO}" ]; then
  echo -e "fastRTPS is already installed. Skipping installation."
  source /opt/ros/${ROS_DISTRO}/setup.bash
else
  mkdir -p ~/software
  cd ~/software
  export MAKEFLAGS=-j$(($(grep -c ^processor /proc/cpuinfo) - 0))

  # Fast-RTPS
  if ! ldconfig -p | grep -q "libfastcdr"; then
    git clone --branch 1.0.x https://github.com/eProsima/Fast-CDR.git
    cd Fast-CDR
    mkdir -p build && cd build
    cmake .. && cmake --build . && sudo make install
  else
    echo -e "Fast-CDR is already installed. Skipping installation."
  fi

  # foonathan_memory_vendor
  cd ~/software
  if ! ldconfig -p | grep -q "libfoonathan_memory"; then
    git clone https://github.com/eProsima/foonathan_memory_vendor.git
    cd foonathan_memory_vendor
    mkdir -p build && cd build
    cmake .. && cmake --build . && sudo make install
  else
    echo -e "foonathan_memory is already installed. Skipping installation."
  fi

  # Fast-DDS
  cd ~/software
  if ! ldconfig -p | grep -q "libfastrtps"; then
    git clone --branch 2.6.8 https://github.com/eProsima/Fast-DDS.git
    cd Fast-DDS
    mkdir -p build && cd build
    cmake .. && cmake --build . && sudo make install
  else
    echo -e "Fast-DDS is already installed. Skipping installation."
  fi
  sudo ldconfig
fi

echo "Dependencies installed successfully"
sudo rm -Rf ~/software
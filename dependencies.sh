#!/bin/bash 
# Please make sure that bin/bash is the location of your bash terminal,if not please replace with your local machine's bash path
branch="${1:-development}"
echo "Installing dependencies for branch $branch"
sudo DEBIAN_FRONTEND=noninteractive apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  \
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
sudo mkdir build
cd build
sudo cmake ..
sudo make install

echo "Installing third-party software Fast-RTPS"

mkdir -p ~/software
cd ~/software
git clone https://github.com/eProsima/Fast-CDR.git
mkdir Fast-CDR/build 
cd Fast-CDR/build
export MAKEFLAGS=-j$(($(grep -c ^processor /proc/cpuinfo) - 0))
cmake ..
cmake --build . 
sudo make install 
cd ~/software
git clone https://github.com/eProsima/foonathan_memory_vendor.git
cd foonathan_memory_vendor
mkdir build 
cd build
cmake ..
cmake --build . 
sudo make install 
cd ~/software
git clone https://github.com/eProsima/Fast-DDS.git
mkdir Fast-DDS/build 
cd Fast-DDS/build
git checkout 2.6.8
cmake ..
cmake --build . 
sudo make install
sudo ldconfig
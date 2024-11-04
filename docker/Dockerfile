ARG base_image=ubuntu:22.04
ARG branch="development"
ARG dsr_version="ros"
ARG ros_distro="humble"
ARG ros_version=$ros_distro"-ros-base-jammy"

FROM ${base_image} AS ubuntu-base
ARG branch
# LABEL about the custom image
LABEL maintainer="ajtudela@uma.es"
LABEL version="0.1"
LABEL description="This is custom Docker image for Cortex"
RUN echo "Building with branch ${branch}"
# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update && apt install --no-install-recommends -y \
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
    && rm -rf /var/lib/apt/lists/*

# Install third party software
RUN git clone https://github.com/ryanhaining/cppitertools /usr/local/include/cppitertools
WORKDIR /usr/local/include/cppitertools
RUN mkdir -p build && cd build && cmake .. && make install
RUN mkdir -p /software
WORKDIR /software
RUN git clone --branch 1.0.x https://github.com/eProsima/Fast-CDR.git
WORKDIR /software/Fast-CDR
RUN mkdir -p build && cd build && cmake .. && make install
WORKDIR /software
RUN git clone https://github.com/eProsima/foonathan_memory_vendor.git
WORKDIR /software/foonathan_memory_vendor
RUN mkdir -p build && cd build && cmake .. && make install
WORKDIR /software
RUN git clone --single-branch --branch 2.6.8 --depth 1 https://github.com/eProsima/Fast-DDS.git
WORKDIR /software/Fast-DDS
RUN mkdir -p build && cd build && cmake .. && make install
RUN ldconfig
RUN rm -rf /software

# Install Cortex
WORKDIR /
RUN git clone --single-branch --branch ${branch} --depth 1 https://github.com/grupo-avispa/cortex.git
WORKDIR /cortex
RUN mkdir -p build && cd build && cmake .. && make install
RUN rm -rf /cortex

FROM ${base_image} AS base-version
COPY --from=ubuntu-base /usr/local /usr/local
RUN apt update && apt install --no-install-recommends -y \
    ca-certificates \
    libopenscenegraph-dev \
    libeigen3-dev \
    libqglviewer-dev-qt5 \
    qtbase5-dev \
    libtinyxml2-dev

FROM ros:${ros_version} AS ros-base
ARG branch
# LABEL about the custom image
LABEL maintainer="ajtudela@uma.es"
LABEL version="0.1"
LABEL description="This is custom Docker image for Cortex"
RUN echo "Building with branch ${branch}"
# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update && apt install --no-install-recommends -y \
    build-essential \
    ca-certificates \
    cmake \
    sudo \
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
    && rm -rf /var/lib/apt/lists/*

# Install third party software
RUN git clone https://github.com/ryanhaining/cppitertools /usr/local/include/cppitertools
WORKDIR /usr/local/include/cppitertools
RUN mkdir -p build && cd build && cmake .. && make install
RUN ldconfig

# Install Cortex
WORKDIR /
RUN git clone --single-branch --branch ${branch} --depth 1 https://github.com/grupo-avispa/cortex.git
WORKDIR /cortex
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
    mkdir -p build && \
    cd build && \
    cmake .. && \
    make install
RUN rm -rf /cortex

FROM ros:${ros_version} AS ros-version
COPY --from=ros-base /usr/local /usr/local
RUN apt update && apt install --no-install-recommends -y \
    ca-certificates \
    libopenscenegraph-dev \
    libeigen3-dev \
    libqglviewer-dev-qt5 \
    qtbase5-dev \
    libtinyxml2-dev

FROM ${dsr_version}-version AS final
ARG dsr_version
RUN echo "Built ${dsr_version} CORTEX"
CMD ["/bin/bash"]

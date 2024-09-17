ARG base_image=ubuntu:22.04
ARG branch="development"
ARG dsr_version="ros"
ARG ros_version="humble-ros-core-jammy"

FROM ${base_image} AS ubuntu-base
# LABEL about the custom image
LABEL maintainer="ajtudela@uma.es"
LABEL version="0.1"
LABEL description="This is custom Docker image for Cortex"
RUN echo "Building with branch $Branch"
# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update && apt install -y \
    build-essential \
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
RUN curl -o- -L https://raw.githubusercontent.com/grupo-avispa/cortex/development/installation.sh | bash -x

FROM ${base_image} AS base-version
COPY --from=ubuntu-base /usr/local /usr/local

FROM ros:${ros_version} AS ros-base
# LABEL about the custom image
LABEL maintainer="ajtudela@uma.es"
LABEL version="0.1"
LABEL description="This is custom Docker image for Cortex"
RUN echo "Building with branch $Branch"
# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update && apt install -y \
    build-essential \
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
RUN curl -o- -L https://raw.githubusercontent.com/grupo-avispa/cortex/development/installation.sh | bash -x

FROM ros:${ros_version} AS ros-version
COPY --from=ros-base /usr/local /usr/local
RUN apt update && apt install -y libopenscenegraph-dev

FROM ${dsr_version}-version AS final
ARG dsr_version
RUN echo "Built ${dsr_version} CORTEX"
CMD ["/bin/bash"]

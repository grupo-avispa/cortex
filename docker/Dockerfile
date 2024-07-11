FROM ubuntu:22.04
# LABEL about the custom image
LABEL maintainer="ajtudela@uma.es"
LABEL version="0.1"
LABEL description="This is custom Docker image for Cortex"
RUN echo "Building with branch $Branch"
# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

COPY . /cortex/
# Update Ubuntu Software repository
RUN apt update && apt install -y \
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
#    && rm -rf /var/lib/apt/lists/*
WORKDIR /cortex/
RUN bash -x installation.sh


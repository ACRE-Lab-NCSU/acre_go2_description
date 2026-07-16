FROM osrf/ros:humble-desktop

# Install development essentials
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    gpg \
    python3-dev \
    python3-colcon-common-extensions \
    cmake \
    build-essential \
    libeigen3-dev \
    ros-humble-rmw-cyclonedds-cpp \
    ros-humble-rosidl-generator-dds-idl \
    ros-humble-realsense2-description \
    ros-humble-joint-state-publisher-gui \
    libyaml-cpp-dev \
    nlohmann-json3-dev \
    && rm -rf /var/lib/apt/lists/*

# Entrypoint
RUN printf '#!/bin/bash\n\
source /opt/ros/humble/setup.sh\n\
exec "$@"\n' > /entrypoint.sh && chmod +x /entrypoint.sh

COPY . /workspace
WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
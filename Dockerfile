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
    ros-humble-joint-state-publisher-gui \
    ros-humble-realsense2-description \
    libyaml-cpp-dev \
    nlohmann-json3-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone and build Unitree CycloneDDS packages
RUN git clone https://github.com/unitreerobotics/unitree_ros2.git /opt/unitree_ros2 && \
    cd /opt/unitree_ros2/cyclonedds_ws && \
    . /opt/ros/humble/setup.sh && \
    CC=gcc CXX=g++ colcon build --symlink-install

# Entrypoint
RUN printf '#!/bin/bash\n\
source /opt/ros/humble/setup.sh\n\
source /opt/unitree_ros2/cyclonedds_ws/install/setup.bash\n\
if [ -d /ros2_ws/src ]; then\n\
  cd /ros2_ws\n\
  apt-get update\n\
  rosdep install --from-paths src --ignore-src -y || true\n\
  colcon build --symlink-install\n\
  source /ros2_ws/install/setup.bash\n\
fi\n\
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp\n\
exec "$@"\n' > /entrypoint.sh && chmod +x /entrypoint.sh

WORKDIR /ros2_ws
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
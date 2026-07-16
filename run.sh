#!/bin/bash
xhost +local:docker
docker run -it --rm \
    --network host \
    -e DISPLAY=$DISPLAY \
    -e XDG_RUNTIME_DIR=/tmp/runtime-root \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --device /dev/dri \
    -v $(pwd):/workspace:z \
    acre_go2_description
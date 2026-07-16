#!/bin/bash
xhost +local:docker
docker run -it --rm \
    --network host \
    -v $(pwd):/workspace:z \
    acre_ctrl
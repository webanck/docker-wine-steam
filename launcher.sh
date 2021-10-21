#!/bin/bash

CONTAINER_NAME=vaporized_wine
IMAGE=webanck/docker-wine-steam
REMOVE_OLD_CONTAINER=0

while [[ $@ ]]
do
key="$1"
case $key in
    -c|--container_name)
    CONTAINER_NAME="$2"
    shift # past argument
    ;;
    -i|--image)
    IMAGE="$2"
    shift # past argument
    ;;
    -r|--remove)
    REMOVE_OLD_CONTAINER=1
    ;;
    *)
    echo "Unsolved parameter:" $key
    ;;
esac
shift # past argument or value
done

if [[ $REMOVE_OLD_CONTAINER = 1 ]]; then
    sudo docker rm $CONTAINER_NAME ||\
    echo $CONTAINER_NAME "not found, skip removing phase"
fi

# Choosing the right GPU type to share the right device.
GPU_DEVICE_PARAMETERS=""
source $(dirname "$0")/gpu.sh
[ "$GPU_TYPE" = NVIDIA ] && GPU_DEVICE_PARAMETERS="--device=/dev/nvidiactl --device=/dev/nvidia-uvm --device=/dev/nvidia0"
[ "$GPU_TYPE" = INTEL ] && GPU_DEVICE_PARAMETERS="--device=/dev/dri:/dev/dri"

( \
	echo 'Trying to run a new data container.' && \
	sudo docker run -it \
			-e DISPLAY \
			-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
			-v ~/.Xauthority:/home/wine/.Xauthority \
			--ipc="host" \
			--device=/dev/snd:/dev/snd \
			$GPU_DEVICE_PARAMETERS \
			-v /run/user/`id -u`/pulse/native:/run/user/`id -u`/pulse/native \
			-v `pwd`/shared_directory:/home/wine/shared_directory \
			--net=host \
			--restart=no \
			--name "$CONTAINER_NAME" \
			$IMAGE \
	2>/dev/null \
) || ( \
	echo 'The container already exists, relaunching the old one.' && \
	sudo docker start -ai "$CONTAINER_NAME" \
)

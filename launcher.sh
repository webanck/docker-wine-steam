#!/bin/sh

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

( \
	echo 'Trying to run a new data container.' && \
	sudo docker run -it \
			-e DISPLAY \
			-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
			-v ~/.Xauthority:/home/wine/.Xauthority \
			--ipc="host" \
			--device=/dev/snd:/dev/snd \
			--device=/dev/dri:/dev/dri \
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
#			--device=/dev/nvidiactl --device=/dev/nvidia-uvm --device=/dev/nvidia0 \

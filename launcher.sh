#!/bin/sh

CONTAINER_NAME=vaporized_wine

( \
	echo 'Trying to run a new data container.' && \
	sudo docker run -it \
			-e DISPLAY \
			-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
			-v ~/.Xauthority:/home/wine/.Xauthority \
			--ipc="host" \
			--device=/dev/snd:/dev/snd \
			--device=/dev/nvidiactl --device=/dev/nvidia-uvm --device=/dev/nvidia0 \
			-v /run/user/`id -u`/pulse/native:/run/user/`id -u`/pulse/native \
			-v `pwd`/shared_directory:/home/wine/shared_directory \
			--net=host \
			--restart=no \
			--name "$CONTAINER_NAME" \
			webanck/docker-wine-steam \
	2>/dev/null \
) || ( \
	echo 'The container already exists, relaunching the old one.' && \
	sudo docker start -ai "$CONTAINER_NAME" \
)

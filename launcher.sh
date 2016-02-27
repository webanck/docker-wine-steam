#!/bin/sh

CONTAINER_NAME=vaporized_wine

( \
	echo 'Trying to run a new data container.' && \
	sudo docker run -ti \
			-e DISPLAY \
			-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
			-v ~/.Xauthority:/home/wine/.Xauthority \
			-v /dev/snd:/dev/snd --privileged \
			-v /run/user/`id -u`/pulse/native:/run/user/`id -u`/pulse/native \
			-v `pwd`/shared_directory:/home/wine/shared_directory \
			--net=host \
			--name "$CONTAINER_NAME" \
			webanck/docker-wine-steam \
	2>/dev/null \
) || ( \
	echo 'The container already exists, relaunching the old old one.' && \
	sudo docker start -ai "$CONTAINER_NAME" \
)

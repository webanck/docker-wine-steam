#!/bin/sh

aplay /usr/share/sounds/alsa/Front_Center.wav && \
sudo docker run -ti \
	-e DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-v ~/.Xauthority:/home/wine/.Xauthority \
	-v /dev/snd:/dev/snd --privileged \
	-v /run/user/`id -u`/pulse/native:/run/user/`id -u`/pulse/native \
	--net=host \
	webanck/docker-wine-steam

FROM ubuntu
MAINTAINER Antoine Webanck <antoine.webanck@gmail.com>

# We don't want any interaction from package installation during the docker image building.
RUN export DEBIAN_FRONTEND=noninteractive && \

# We want the 32 bits version of wine allowing winetricks.
	dpkg --add-architecture i386 && \

# Updating and upgrading a bit.
	apt-get update && \
	apt-get upgrade -y && \

# We need software-properties-common to add ppas.
	apt-get install -y --no-install-recommends software-properties-common && \

# Adding required ppas: nvidia's proprietary drivers and wine.
	add-apt-repository ppa:ubuntu-x-swat/x-updates && \
	add-apt-repository ppa:ubuntu-wine/ppa && \
	apt-get update && \

# Installation of nvidia's proprietary.
	apt-get install -y --no-install-recommends nvidia-current && \

# Installation of wine and winetricks.
	apt-get install -y --no-install-recommends wine1.7 winetricks && \
# Installation of winbind to stop ntlm error messages.
	apt-get install -y --no-install-recommends winbind && \
# Installation of pulseaudio support for wine sound.
	apt-get install -y --no-install-recommends pulseaudio libasound2-plugins:i386 && \

# Cleaning up.
	apt-get purge -y software-properties-common && \
	apt-get autoremove -y --purge && \
	apt-get autoclean -y
	
#########################END OF INSTALLATIONS##########################

# Creating a wine user: replace 1001 by your user id (id -u).
RUN useradd -u 1001 -d /home/wine -m -s /bin/bash wine && export PULSE_SERVER=unix:/run/user/1001/pulse/native

# Adding some helper scripts.
COPY finalize_installation.sh /home/wine/.finalize_installation.sh
RUN chown wine:wine /home/wine/.finalize_installation.sh && \
	chmod o+x /home/wine/.finalize_installation.sh && \
	echo 'export "PULSE_SERVER=unix:/run/user/`id -u`/pulse/native"' >> /home/wine/.bashrc && \
	echo 'alias finalize_installation="bash /home/wine/.finalize_installation.sh"' >> /home/wine/.bashrc && \
	echo 'alias steam="wine /home/wine/.wine/drive_c/Program\ Files/Steam/Steam.exe"' >> /home/wine/.bashrc

# Setting up a non-root environment dedicated to wine.
USER wine
ENV HOME /home/wine
WORKDIR /home/wine
ENV WINEPREFIX /home/wine/.wine
ENV WINEARCH win32


# Launching the shell by default.
CMD /bin/bash

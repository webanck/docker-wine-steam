#!/bin/sh

# Getting the user id.
MYUID=`id -u`

# Copying the Dockerfile to set parameters.
cp -f Dockerfile /tmp/ && cp -f finalize_installation.sh /tmp/

# Setting the right user id.
sed -i -e "s/1001/$MYUID/g" /tmp/Dockerfile

# Stripping the escapements of the end of lines to allow incremental build of the docker image (build testing vs size optimization).
#sed -i -e 's/ && \\//g' /tmp/Dockerfile
#sed -i -e 's/^	/RUN /g' /tmp/Dockerfile

# Building the image.
sudo docker build -t webanck/docker-wine-steam /tmp/ 

# Cleaning up.
rm /tmp/Dockerfile /tmp/finalize_installation.sh

#!/bin/sh

# Getting the user id.
MYUID=`id -u`

TMP_DIR=/tmp/docker-wine-steam

# Copying the Dockerfile to set parameters.
mkdir $TMP_DIR 
cp -f Dockerfile $TMP_DIR/ && cp -f finalize_installation.sh $TMP_DIR/

# Setting the right user id.
sed -i -e "s/1001/$MYUID/g" $TMP_DIR/Dockerfile

# Stripping the escapements of the end of lines to allow incremental build of the docker image (build testing vs size optimization).
#sed -i -e 's/ && \\//g' $TMP_DIR/Dockerfile
#sed -i -e 's/^	/RUN /g' $TMP_DIR/Dockerfile

# Building the image.
sudo docker build -t webanck/docker-wine-steam $TMP_DIR/ 

# Cleaning up.
rm $TMP_DIR/Dockerfile $TMP_DIR/finalize_installation.sh

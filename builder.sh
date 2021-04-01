#!/bin/sh

# Choosing the right GPU type to install the right driver.
GPU_TYPE=""

# Uncomment for manual choice.
#GPU_TYPE=NVIDIA
#GPU_TYPE=INTEL

[ -z "$GPU_TYPE" ] && DISPLAY_STR=$(sudo lshw -C display)
[ -z "$GPU_TYPE" ] && echo "$DISPLAY_STR" | grep -i nvidia && GPU_TYPE=NVIDIA
[ -z "$GPU_TYPE" ] && echo "$DISPLAY_STR" | grep -i intel && GPU_TYPE=INTEL

echo "GPU type chosen: $GPU_TYPE"

# Getting the user id.
MYUID=$(id -u)

TMP_DIR=/tmp/docker-wine-steam

# Temporary copies of files to be included in image.
mkdir $TMP_DIR 
cp -f Dockerfile $TMP_DIR/ && cp -f finalize_installation.sh $TMP_DIR/

# Building the image.
sudo docker build -t webanck/docker-wine-steam --build-arg WINE_USER_UID=$MYUID --build-arg GPU_TYPE=$GPU_TYPE $TMP_DIR/ 

# Cleaning up.
rm $TMP_DIR/Dockerfile $TMP_DIR/finalize_installation.sh

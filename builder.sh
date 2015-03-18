#!/bin/sh

# Getting the user id.
UID=`id -u`

# Checking for the right graphic driver to install.
VGA_CARDS=`lspci | grep VGA`

NVIDIA_CARDS=`echo $VGA_CARDS | grep NVIDIA | wc -l`
ATI_CARDS=`echo $VGA_CARDS | grep ATI | wc -l`
INTEL_CHIPSETS=`echo $VGA_CARDS | grep Intel | grep Integrated | wc -l`

NVIDIA_CARD_PACKAGES='nvidia-current'
#TODO: check if the extra step of sudo amdconfig --initial is needed.
ATI_CARD_PACKAGES='fglrx xvba-va-driver libva-glx1 libva-eg11 vainfo'
#TODO: installation of latest intel's drivers with gui installer http://www.maketecheasier.com/install-intel-graphics-drivers-linux/ .
INTEL_CHIPSET_PACKAGES='libgl1-mesa-dri:i386'

if [ $NVIDIA_CARDS -gt 0 ]
then
	PACKAGES=$NVIDIA_CARD_PACKAGES
elif [ $ATI_CARDS -gt 0 ]
then
	PACKAGES=$ATI_CARDS
elif [ $INTEL_CHIPSETS -gt 0 ]
then
	PACKAGES=$INTEL_CHIPSET_PACKAGES
else
	echo 'No supported GPU, please check your hardware and modify the script accordingly.'
fi

# Copying the Dockerfile to set parameters.
cp -f Dockerfile /tmp/ && cp -f finalize_installation.sh /tmp/

# Setting the right user id.
sed -i -e "s/1001/$UID/g" /tmp/Dockerfile

# Setting the right graphic packages.
sed -i -e "s/nvidia-current/$PACKAGES/g" /tmp/Dockerfile

# Building the image.
sudo docker build -t webanck/docker-wine-steam /tmp/ 

# Cleaning up.
rm /tmp/Dockerfile /tmp/finalize_installation.sh

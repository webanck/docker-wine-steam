#!/bin/bash

GPU_TYPE=""

# Uncomment for manual choice.
#GPU_TYPE=NVIDIA
#GPU_TYPE=INTEL

[ -z "$GPU_TYPE" ] && DISPLAY_STR=$(sudo lshw -C display)
[ -z "$GPU_TYPE" ] && echo "$DISPLAY_STR" | grep -i nvidia && GPU_TYPE=NVIDIA
[ -z "$GPU_TYPE" ] && echo "$DISPLAY_STR" | grep -i intel && GPU_TYPE=INTEL

echo "GPU type chosen: $GPU_TYPE"

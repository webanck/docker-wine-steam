#!/bin/bash

winecfg
winetricks --no-isolate steam

echo "You can now launch steam just by typing 'steam'."

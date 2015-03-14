#!/bin/bash

winecfg
winetricks -q corefonts #Needed by allmost everything.
winetricks -q dotnet20 #Needed by d3dx9 installation.
winetricks -q dotnet40 #Needed by Terraria.
winetricks -q xna40 #Needed by Terraria.
winetricks d3dx9 #Needed by games.
winetricks -q directplay #Needed by windows games multiplayer.
winetricks --no-isolate steam

echo "Vous pouvez relancer steam simplement en tapant 'steam'."

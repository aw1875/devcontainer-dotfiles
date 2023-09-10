#!/bin/bash

##### Colours #####
# Reset
Color_Off='\033[0m\n'       # Text Reset

# Regular Colors
Green='\033[0;32m'          # Green
Cyan='\033[0;36m'           # Cyan

alias cls='printf "\033c"'
##### Colours End #####

# Current Script Directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Check if .config folder exists
mkdir -p "$HOME/.config"

# Setup Symlinks
printf "${Cyan}Creating Symlinks${Color_Off}"
ln -nsf "$SCRIPT_DIR/nvim" $HOME/.config

printf "${Green}Done!${Color_Off}"

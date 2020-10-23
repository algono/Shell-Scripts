#!/bin/bash
# shellcheck disable=SC1090

## Script made by: Alejandro Gomez - algono - 09/04/2019

request_folder()
{
	echo "Specify the path you want to add to PATH:"
	echo "[Default: Current path]"
	echo ""
	read -r
	echo ""
	
	## If no reply, uses current path as default
	if [ -z "$REPLY" ]
	then
		FOLDER=$(pwd)
	else
		FOLDER=$REPLY
	fi
	
	## Code for testing purposes
	#echo "Indicated path: $FOLDER"
	#read
	
	clear
}

add_folder_to_path()
{
	if [ -z "$FOLDER" ]
	then
		request_folder
	fi
	## Get PATH addition line
	local LINE
	LINE=$(grep "PATH=" "$HOME/.bash_profile")
	
	## Check if the line contains the keyword
	if [[ $LINE = *"$KEYWORD"* ]]
	then
		## If it does, it supposes that it is already in path, but lets the user decide
		echo "The path is supposedly already in PATH. Check it here."
		echo "$LINE"
		read -p "Continue adding to PATH? (Y/N): " -n 1 -r
		echo ""
		if [[ ! $REPLY =~ ^[Yy]$ ]]
		then
			echo "The path was not added to PATH."
			return 1
		fi
	fi
	
	## Add folder passed as an argument to the PATH
	sed -i "/PATH=/c $LINE:$FOLDER" "$HOME/.bash_profile"
	
	## Reload PATH file
	. "$HOME/.bash_profile"
	
	echo "The path was added to PATH successfully."
}

FOLDER="$1"
add_folder_to_path

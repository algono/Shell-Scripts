#!/bin/bash

## Script made by: Alejandro Gomez - algono - 23/02/2019

## FUNCTIONS

request_folder()
{
	if [ "$INSTALLED" = true ]
	then
		echo "Specify the path where Maude is installed"
	else
		echo "Specify the path where Maude should be installed"
	fi
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

install_maude()
{
	INSTALLED=false
	
	if [ -z "$FOLDER" ]
	then
		request_folder
		FOLDER+="/maude"
	fi
	
	## Download Maude
	curl -o maude.zip http://maude.cs.illinois.edu/w/images/5/5d/Maude-2.7.1-linux.zip

	## Unzip downloaded file
	unzip -d $FOLDER maude.zip
	rm maude.zip
	
	## Give execution permissions
	chmod +x "$MAUDE"
	
	INSTALLED=true
}

##  Add Maude path to Systems PATH
## (only if the keyword isnt already in the PATH)
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
		echo "Maude is supposedly already in path. Check it here."
		echo "$LINE"
		read -p "Continue adding to PATH? (Y/N): " -n 1 -r
		echo ""
		if [[ ! $REPLY =~ ^[Yy]$ ]]
		then
			echo "Maude was not added to PATH."
			return 1
		fi
	fi
	
	## Add folder passed as an argument to the PATH
	sed -i "/PATH=/c $LINE:$FOLDER" "$HOME/.bash_profile"
	
	## Reload PATH file
	. "$HOME/.bash_profile"
	
	echo "Maude was added to PATH successfully."
}

## Add alias (when calling 'maude' it runs the proper file)
add_alias()
{
	if [[ $(cat "$HOME/.bash_aliases") == *"alias $ALIAS="* ]]
	then
		echo "Error. The alias is already defined."
		return 1
	fi
	
	echo "Adding alias..."
	touch "$HOME/.bash_aliases"
	echo "alias $ALIAS='\\$COMMAND'" >> "$HOME/.bash_aliases"

	## Reload Aliases and PATH files
	. "$HOME/.bash_aliases"
	. "$HOME/.bash_profile"

	if [[ $(cat "$HOME/.bashrc") != *"~/.bash_aliases"* ]]
	then
		load_aliases_by_default
	fi
	
	echo "Alias added successfully."
	echo "Type the command '. ~/.bash_aliases' to update the changes."
}

load_aliases_by_default()
{
cat >> "$HOME/.bashrc" <<EOL

# Alias definitions
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOL
}

## MAIN SCRIPT

KEYWORD='maude'
ALIAS='maude'
MAUDE="maude.linux64"

## By default, it assumes it is installed, because most of the options require for it to be
INSTALLED=true

while :
do
	VALID=true
	clear
	echo ---------
	echo "Welcome to Maude's installer on Linux."
	echo ---------
	echo "1- Full instalation"
	echo ---------
	echo "Custom Installation"
	echo -----
	echo "2- Install Maude"
	echo "3- Add Maude to PATH"
	echo "4- Create 'maude' command (Maude must be in PATH)"
	echo ---------
	echo "0- Exit"
	echo ---------
	read -r -p "Choose one: "
	
	clear
	case $REPLY in
		[12])
			install_maude
			;;&
		[13])
			add_folder_to_path
			;;&
		[14])
			add_alias
			;;
		0)
			exit 0
			;;
		*) VALID=false;;
	esac
	if [ $VALID == true ]
	then
		echo
		echo "Finished. Press any key to continue..."
		read -n 1 -r
	fi
done

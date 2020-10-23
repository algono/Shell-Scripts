#!/bin/bash

## Script made by: Alejandro Gomez - algono - 24/02/2019

## FUNCTIONS

create_alias()
{
	read -r -p "Type the name of the new alias: " ALIAS
	echo ---------
	read -r -p "Type the full command the alias should do: " COMMAND
}

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

	echo "Alias added successfully."
	echo "Type the command '. ~/.bash_aliases' to update the changes."
}

add_aliases_no_arguments()
{
	while :
	do
		clear
		echo ---------
		echo "Welcome to the alias creation system."
		echo ---------
		create_alias
		echo ---------
		add_alias
		echo ---------
		read -p "Press any key to add another alias... (or press 'q' to exit)" -n 1 -r
		echo ""
		if [ "$REPLY" = "q" ]; then return 0; fi
	done 
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

if [ "$#" -gt 0 ]; then
	if [ "$#" -ne 2 ]; then
		echo "Illegal number of parameters. Only 0 (multi-alias) or 2 (one-alias) parameters are valid."
		exit 1
	else
		ALIAS=$1
		COMMAND=$2
		add_alias
	fi
else
	add_aliases_no_arguments
fi

if [[ $(cat "$HOME/.bashrc") != *"~/.bash_aliases"* ]]
then
	load_aliases_by_default
fi

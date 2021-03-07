#!/bin/bash
if test ! -d $HOME/.opendchub; then
	echo "creating config directory: $HOME/.opendchub"
	mkdir $HOME/.opendchub
	chmod 700 $HOME/.opendchub
else
	echo "$HOME/.opendchub already exists!"
fi
if test ! -d $HOME/.opendchub/scripts; then
	echo "creating script directory: $HOME/.opendchub/scripts"
	mkdir $HOME/.opendchub/scripts
	chmod 700 $HOME/.opendchub/scripts;
	echo "copying scripts..."
	for i in /usr/share/opendchub/scripts/*; do
		cp $i $HOME/.opendchub/scripts;
	done
else
	echo "$HOME/.opendchub/scripts already exists!"
fi
echo "done!"

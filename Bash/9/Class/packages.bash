#!/bin/bash

# Search fo installed packages.
# Prompt the user to input a package name.

echo -n "Please input a package name: "

# Create a variable fo user input
read package

if [[ "${package}" == "" ]]
then
	echo "No package name provided"
	#exit 1

fi

# Command to run
cmd=$(dpkg -l | egrep -i "${package}")

# Check to see if there is any output
if [[ "${cmd}" =~ "${package}" ]]
then

	echo "Package ${package} is installed."
	#exit 0

else

	echo "Package ${package} is not installed"
	#exit 1

fi

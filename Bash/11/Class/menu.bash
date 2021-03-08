#!/bin/bash

# Script for system admins and security admins

# show the main menu
function showMenu {

	#Create the main menu
	clear
	
	# Provide the menus
	echo  "1. System Administration Menu"
	echo  "2. Security Administration Menu"
	echo  "[E]xit"

	read -p "Please enter an option above:   " menuOption

	if [[ ${menuOption} == 1 ]]
	then
	
		sysAdminMenu
	
	elif [[ ${menuOption} == 2 ]]
	then
		secAdminMenu

	elif [[ ${menuOption} == "E" ]]
	then
		# Exits the program
		exit 0

	else
		echo "Invalid input"

		sleep 2

		showMenu
	fi
} # close showMenu function

function sysAdminMenu() {

	clear

	echo "1. List running processes"
	echo "2. List all installed packages"
	echo "3. Search for an installed package"
	echo "4. Currently logged in users"
	echo "[R] Return to main menu"
	echo "[E]xit"

	read -p "Please select an option above: " sysOption

	# Process the options
	case "${sysOption}" in

	"1")	
		ps -ef | less
		;;

	"2")

		# Show all packages
		dpkg -l | less
		;;

	"3")
		# Search for package
		~/fa19-sys320-mathieson/Bash/9/Class/packages.bash

		# Because we are displaying a value on screen
		# we need to pause the script execution
		read
		;;

	"4")

		# Current users
		w | less
		;;

	[rR])
		# Return to main menu
		showMenu
		;;

	[eE])		
		echo "Closing the program..."
		exit 0 
		;;

	*)
		echo "Invalid input"
		sleep 2 
		sysAdminMenu
		;;
	esac

sysAdminMenu	
} # End of sysAdminMenu

# Show the main menu
showMenu



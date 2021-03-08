#!/bin/bash
# Script to view Apache logs via a GUI and generate a block list for bad IPs.

function which_ruleset() {

	the_ruleset=$(yad --form --title="Select Ruleset" --field="Select Ruleset:CB" "IPTables\!Cisco\!Windows Firewall")

}

function console_status() {

	# Get the return value
	retVal=$?

	# Allow user to see logs again
	if [[ ${retVal} -eq 10 ]]
	then
		view_logs

	else

		# Or exit if select no
		exit 0
	fi
}

function view_logs() {

	# Present the apache access log screen
	block_ip=$(yad --height=300 --list --checklist --width=800 --column="Select IP" --column=ip --column=date --column=method \
		--column=status --column=fsize --column=uri $(cat parse.apache) 2>/dev/null)


# Count the number of rules.
num_rules=$(echo ${block_ip} | awk -F"|" ' { print NF } ')


# If no rules are selected, the value of ${num_rules} will be 0.
if [[ ${num_rules} -eq 0 ]]
then

	# Prompt for finding no IPs selected
	yad --text="No IPs were selected. Would you like to view the logs again?" \
		--button="Yes":10 --button="No":20

	console_status

	else


		# Get the IP address (field $2) from the yad output and format the results into an IPTables drop rule
		which_ruleset


		# File save dialog will 
		ruleset=$(echo "${the_ruleset}" | awk -F"|" ' { print $1 } ')


		case ${ruleset} in
	
		"IPTables")
			echo "${ruleset}"
			# Get the IP address field $2 from the ruleset
			the_rules=$(echo "${block_ip}" | sort -u | awk -F"|" ' { print "iptables -A INPUT " $2 " -j DROP\n"} ')
			;;

		"Cisco")
			the_rules=$(echo "${block_ip}" | sort -u | awk -F"|" ' { print "iaccess-list 1 deny host " $2 "\n"} ')
			;;

		"Windows Firewall")
			the_rules=$(echo "${block_ip}" | sort -u | awk -F"|" ' { print "netsh advfirewall firewall add rule name=\"IP BLOCK\" dir=in interface=any action=block remoteip="$2"/32\n"} ')

			;;

		*)
			echo "Invalid Option"
			sleep 2
			view_logs
			;;

		esac

	# file save dialog
	save_ip=$(yad --file --directory --save --width=600 --height=400)
	

	# Save the IPs to the file specified.
	# |& tee is the same as >
	echo "${the_rules}" |& tee ${save_ip}

	# Prompt to view the logs again.
	yad --text="Would you like to view the logs again?" \
		--button="Yes":10 \
		--button="No":20
	
	# Call function to determin if showing log console again or exit the program
	console_status
fi

} # end view_logs function
# Display the main menu
view_logs

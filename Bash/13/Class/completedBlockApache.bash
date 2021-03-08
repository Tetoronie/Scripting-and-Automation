#!/bin/bash

# Select a firewall ruleset
function which_ruleset() {

	the_ruleset=$(yad --form --title="Select Ruleset" --field="Select Ruleset:CB" "IPTables\!Cisco\!Windows Firewall")

}

function console_status() {

	# Get the value of the exit status, we set above with the buttons
        retVal=$?

        # Allow the user to see the logs again
        if [[ ${retVal} -eq 10 ]]
        then

              view_logs

        else

              # Or exit if they select No.
              exit 0

        fi

}

function view_logs() {

	# Present the apache access log screen
	block_ip=$(yad --height=300 --list --checklist --width=800 --column="Select IP" --column=ip --column=tdate --column=method --column=status --column=fsize --column=ua `cat parse.apache` 2>/dev/null)
	
	# Count the number of rules.
	num_rules=$(echo ${block_ip} | awk -F"|" ' { print NF } ')
	
	# If no rules are selected, the value of ${num_rules} will be 0.
	if [[ ${num_rules} -eq 0 ]]
	then
	
		# Prompt for finding no IPs selected
		yad --text="No IPs were selected. Would you like to view the logs again?" \
			--button="Yes":10 \
			--button="No":20
	
		console_status
	
	else 
	
	
		# Select the ruleset to create
		which_ruleset
	
		ruleset=$(echo "${the_ruleset}" | awk -F"|" ' { print $1 } ')
	
		case "${ruleset}" in
	
			"IPTables")
	
				echo "${ruleset}"
				# Get the IP address (field $2) from the yad output and format the results into an IPTables drop rule
				the_rules=$(echo "${block_ip}" | sort -u | awk -F"|" ' { print "iptables -A INPUT -s " $2 " -j DROP\n"} ')
	
				;;
			"Cisco")
	
				the_rules=$(echo "${block_ip}" | sort -u | awk -F"|" ' { print "access-list 1 deny host " $2 "\n"} ')
				;;
			"Windows Firewall")
	
				the_rules=$(echo "${block_ip}" | sort -u | awk -F"|" ' { print "netsh advfirewall firewall add rule name=\"IP Block\" dir=in interface=any action=block remoteip="$2"/32\n"} ')
				;;
			*)
	
				echo "Invalid Value! No one should see this message."
				sleep 2
				view_logs
	
				;;
	
		esac
	
	
		# File save dialog will 
		save_ip=$(yad --file --directory --save --width=600 --height=400)
	
		# Save the IPs to the file specified.
		echo "${the_rules}" |& tee ${save_ip}
	
		# Prompt to view the logs again.
		yad --text="Would you like to view the logs again?" \
			--button="Yes":10 \
			--button="No":20
	
		console_status
	
	fi

} # end view_logs function
# Display the main menu
view_logs

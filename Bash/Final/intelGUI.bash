#!/bin/bash
# Script to create firewall rules for known bad domains from malwaredomainlist.com
# Created by Christopher Mathieson



function which_format() {

	the_format=$(yad --form --title="Select Format" --field="Select Format:CB" "IPTables\!Cisco Threat Manager")

}

function console() {

	#return value
	retVal=$?

	# Open logs again
	if [[ ${retVal} -eq 10 ]]
	then
		view_domains

	else
		# Exit instead
		exit 0
	fi	
}

function view_domains() {

	# Split and extract host and description fields from file into two separate files 
	sed -e 's/\"//g' domain.csv | awk -F,  '{ print $5 }' | sed 's/ /_/g' > description.txt
	sed -e "s/\"//g" -e "s/\,/ /g" domain.csv | awk ' { print $3 } ' | sed "s/^/X /g" > hosts.txt
	
	# Combine the host and description into one file
	paste hosts.txt description.txt > stripped.txt

	domain_list=$(yad --height=500 --list --checklist --width=500 --column="Select Host" --column=Host --wrap-width=300 --column=Type \
		$(cat stripped.txt) 2>/dev/null)


	# Count Number of IPs
	number=$(echo ${domain_list} | awk -F"|" ' { print NF } ')

	if [[ ${number} -eq 0 ]]
	then

		# Bring user back if no IPs are selected
		yad --text="No IPs were selected. Please select some IPs before trying to block or exit."\
			--button="Back":10\
			--button="Exit":20

		console
	

	else

		# Call function to choose ruleset format	
		which_format

		# Pull ruleset name for case matching
		format=$(echo "${the_format}" | awk -F"|" '{ print $1 } ')

		case ${format} in
		
			"IPTables")
				echo "${format}"

				rules=$(echo "$domain_list}" | sort -u | awk -F"|" '\
				       	{ print "iptables -I OUTPUT -p tcp --dport 80 -m string --algo bm --string \x27" $2 "\x27 -j DROP\n"} ')
				# Apply ruleset with iptables function
				iptables_rules
				;;

			"Cisco Threat Manager")
				echo "${format}"

				rules=$(echo "$domain_list}" | sort -u | awk -F"|" '\
					{ print "parameter-map type regex urlf_blacklist_pma1\n" "pattern " $2 "\n"} ')
				
				# Save rules to user defined file
				cisco_rules
				;;

			esac 

	# Prompt to review domains
	yad --text="View hosts again?"\
		--button="Yes":10\
		--button="No":20

	console



	fi
}

function iptables_rules() {
	# Save iptables to file
	echo "${rules}" > iptables-urls.bash

	# Apply ruleset
	bash iptables-urls.bash
	iptables -L -n
}

function cisco_rules() {

	# Save rules with directory dialog box
	save_dir=$(yad --file --directory --save --width=500 --height=400)
	echo "${rules}" > ${save_dir}

}

file=domain.csv
# Check for file and Download malware list if not found
if [[ ! -f "$file" ]];
then
	
	wget http://malwaredomainlist.com/mdlcsv.php -O domain.csv
		
fi

# call main function
view_domains

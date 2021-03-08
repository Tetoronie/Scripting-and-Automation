#!/bin/bash
# Script to perform a dns lookup on a /24 network

# Generate the last octet
last_octet=$(seq 1 254)

# Loop through the results
for octet in ${last_octet}
do
	cmd=$(host 192.168.4.${octet})

	# Check to see if there is a corresponding hostname
	if [[ "${cmd}" =~ "domain name pointer" ]]
	then

		aRecord=$(echo "${cmd}" | awk ' {print $5} ')
		echo "The IP: 192.168.4.${octet} has the hostname ${aRecord}"

	else
		echo "The IP: 192.168.4.${octet} has no hostname"

	fi
done

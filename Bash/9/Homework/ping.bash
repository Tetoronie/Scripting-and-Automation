#!/bin/bash
# Script to ping all available IPs on 192.168.4.0/24 network


octet=$(seq 0 255)


# Loops through every host ID 
for host in ${octet}
do

  # Check to see if host ID is .0 or .255 so it does not ping
  if [[ "${host}" = "0" ]] || [[ "${host}" = "255" ]]
  then
    echo "The IP: 192.168.4.${host} cannot be pinged on a /24 subnet"

  # ping all other usable Host IPs
  else
	# Command to ping. Pings twice to check if host is up
  	ping=$(ping -c 2 192.168.4.${host})

        # Host is up check
  	if [[ "${ping}" =~ "64 bytes from" ]]
  	then
    		echo "The host: 192.168.4.${host} is up"

	# Host is down check
  	elif [[ "${ping}" =~ "100% packet loss" ]]
  	then
    		echo "The host: 192.168.4.${host} is down"
  	fi
  fi
done

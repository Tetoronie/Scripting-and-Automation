#!/bin/bash

# Parse an apache web log and look for malicious queries

# Read in the apache file
APACHE_LOG="$1"

# Check if the file exists.
if [[ ! -f ${APACHE_LOG} ]]
then
	echo "The file doesn't exist."
	echo "Please check the path."
	exit 1

fi

# search and replace the brackets and double quotes
sed -e "s/\[//g" -e "s/\"//g" ${APACHE_LOG} | \
	egrep -i "test|shell|echo|passwd|phpmyadmin|select|setup|admin|w00t" | \
	awk 'BEGIN { format = "%-15s %-20s %-7s %-6s %-10s %s\n"

		printf format, "IP", "Date", "Method", "Status", "Size", "URI"
		printf format, "--", "----", "------", "------", "----", "---" }

{ printf format, $1, $4, $6, $9, $10, $7}'

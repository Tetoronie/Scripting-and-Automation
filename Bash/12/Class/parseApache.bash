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


# Start of block comment
: <<'end'
# search and replace the brackets and double quotes
sed -e "s/\[//g" -e "s/\"//g" ${APACHE_LOG} | \
	egrep -i "test|shell|echo|passwd|phpmyadmin|select|setup|admin|w00t" | \
	awk 'BEGIN { format = "%-15s %-20s %-7s %-6s %-10s %s %s\n"

		printf format, "IP", "Date", "Method", "Status", "Size", "URI  ", "User Agent"
		printf format, "--", "----", "------", "------", "----", "-----", "----------" }

{
       
	# Check to see if the User Agent is not blank
	if ($12 == "-") {

		print "No User Agent"
	} else {
		# starting field for the User Agent
		start = 12
	}

	# Create a for loop that will start at the defined value
	# and count the number of fields until the end of the line
	# NF means end of line, keep adding to i until end of line
	ua = ""; for (i = start; i <= NF ; i++)

		ua = ua " " $i;

		# Standard Console print
		#printf format, $1, $4, $6, $9, $10, $7, ua

		# Create Variables for our CSV format
		q = "\""
		cq = "\","

		# parenthesis concatenates into one field
		print q$1cq q$4cq q$6cq q$9cq q$10ca q$7cq (q ua cq)

}'
end
# end of block comment


# TASK: Add the column headers to the CSV file and it should only appear once at the beginning of the file. Do not over think this.



sed -e "s/\[//g" -e "s/\"//g" ${APACHE_LOG} | \
	egrep -i "test|shell|echo|passwd|phpmyadmin|select|setup|admin|w00t" | \
	awk 'BEGIN { format = "%-15s %-20s %-7s %-6s %-10s %s %s\n"

		printf format, "\"IP\",", "\"Date\",", "\"Method\",", "\"Status\",", "\"Size\",", "\"URI\",", "\"UA\"" }

{

	# Check to see if the User Agent is not blank
	if ($12 == "-") {

		print "No User Agent"
	} else {
		# starting field for the User Agent
		start = 12
	}

		ua = ""; for (i = start; i <= NF ; i++)
		ua = ua " " $i;
		
		# Create Variables for our CSV format
		q = "\""
		cq = "\","

		print q$1cq q$4cq q$6cq q$9cq q$10cq q$7cq (q ua cq)
	}' > apachelog.csv 
		

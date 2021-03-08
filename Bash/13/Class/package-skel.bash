#!/bin/bash


# Create the GUI to enter a package name.
package=$(yad --width=400 --title="" --text="Please enter a package name:" --form --field="Package Name")

# Parse the output of Yad to retrieve the value the user entered
# Note how awk is changing its default field delimeter.
pname=$(echo "${package}" | awk -F"|" ' {print $1 } ')

# Search for the package.
value=$(dpkg -l | egrep -i ${pname})

# Check if the package does or doesn't exist.
if [[ $value == "" ]]
then

	# Display no results found.
	yad --text="${pname} was not found" --text-align=center
else

	
	# Create a random temp file.
	TMPFILE=$(mktemp)

	# print the package name and version.
	echo "${value}" | awk ' { print $2, $3 } ' > ${TMPFILE}

	# Test to view the results of the TMPFILE
	cat ${TMPFILE}

	# Display the results in two columns.
	yad --list --height=500 --width=300 --column=Package --column=Version $(cat ${TMPFILE}) 


	rm -f ${TMPFILE}

fi

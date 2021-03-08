#!/bin/bash

# Script to perfom local security checks.

# function to check setting results
function checks() {

if [[ $2 != $3 ]]
then
	# Not compliant
	echo -e "\e[1;31m$1 is not compliant. It should be: $2"
	echo -e "The current value is: $3\e[0m"

else
	# Compliant
	echo -e "\e[1;32m$1 is compliant. Current Value is: $3\e[0m"
fi
} # End of function checks


# Get password policies
pass_check=$(egrep "^PASS_MAX_DAYS|^PASS_MIN_DAYS|^PASS_WARN_AGE" /etc/login.defs)

# Get Pass_Max_Days policy
pmax=$(echo "${pass_check}" | egrep "PASS_MAX_DAYS" |  awk ' { print $2 } ')


# Check for password max
# 	$1		$2	$3
checks "Password maximum" "365" "${pmax}"
echo

# Get Password minimum age policy
pmin=$(echo "${pass_check}" |egrep "PASS_MIN_DAYS" |  awk ' { print $2 } ')

# Check for password minimum
checks "Password minimum days" "14" "${pmin}"
echo


# Get PASS_WARN_AGE Policy
page=$(echo "${pass_check}" | egrep "PASS_WARN_AGE" |  awk ' { print $2 } ')

checks "Password warn age" "7" "${page}"
echo


# SSH usePAM
chkSSHPAM=$(egrep "^UsePAM" /etc/ssh/sshd_config | awk ' { print $2 } ')

checks "SSH UsePAM" "no" "${chkSSHPAM}"
echo


for eachDir in $(ls -l /home | egrep '^d' | awk ' { print $3 } ')
do
	chDir=$(ls -ld /home/${eachDir} | awk ' { print $1 } ')
	checks "Home directory ${eachDir}" "drwx------" "${chDir}"
	echo

done


# Check PermitRootLogin

chkRootLogin=$(egrep "#PermitRootLogin" /etc/ssh/sshd_config | awk ' { print $2 } ' )
checks "Permit Root Login" "prohibit-password" "${chkRootLogin}"
echo

# Check SFTP Subsytem

chkSFTP=$(egrep "^Subsystem" /etc/ssh/sshd_config | awk ' { print $3 } ')
checks "SFTP Subsystem" "/usr/lib/openssh/sftp-server" "${chkSFTP}"
echo

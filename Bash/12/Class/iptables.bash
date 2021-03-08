#!/bin/bash
# Parse an IPTables Log
# Feb 1 00:00:02 bridge kernel: INBOUND TCP: IN=br0 PHYSIN=eth0 OUT=br0 PHYSOUT=eth1 SRC=192.150.249.87 DST=11.11.11.84 LEN=40 TOS=0x00 PREC=0x00 TTL=110 ID=12973 PROTO=TCP SPT=220 DPT=6129 WINDOW=16384 RES=0x00 SYN URGP=0


# Read in the file from the commandline
# Arguments using the position. Arguments start at $1.
IPTABLES_LOG="$1"

# check if the logfile exists
if [[ ! -f ${IPTABLES_LOG} ]]
then

    echo "Please specify the path to a log file."
    exit 1
fi

# Parse iptables Log
sed -e "s/SRC=//g" -e "s/DST=//g" -e "s/SPT=//g" -e "s/DPT=//g" ${IPTABLES_LOG} |  \
	egrep -i "INBOUND TCP:" | \
	awk 'BEGIN { format = "%-15s %-19s %-19s %-8s %-8s\n"

	printf format, "Date", "SRC IP", "DST IP", "SRC Port", "DST Port"
	printf format, "--------", "------", "-------", "-------", "-------" } 

	{ 
		if ($19 != "DF") {

		printf format, $1 " " $2 " " $3, $12, $13, $20, $21 
	} else {

		printf format, $1 " " $2 " " $3, $12, $13, $21, $22
	}
	
}'

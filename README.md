# ARPSpoofEx

ARPSpoofEx is a little wrapper script for several MitM tools.


## Requirements

### Minimal Requirements

* Linux
* arpspoof (Included in dsniff package)

### Optional

* Included in dsniff package:
	* dnsspoof 
	* urlsnarf
* driftnet


## Quickstart

`./ARPSpoofEx.sh -i eth0 -v <IP Address>`
This command will use arpspoof to direct all traffic from the gateway to the victim and reverse over your interface. The IP Address of the router will be determined automatically.

## Parameters


* -h	Help, obviously.
* Required
	* -v	Victim IP Address.
	* -i	Interface
* Optional
	* -r	Router IP Address. Will be determined automatically if not supplied.
	* -n	No Forwarding. All captured packets will not be forwarded to the original destination.
* Optional: Programs
	* -d	driftnet
	* -u	urlsnarf
	* -s	dnsspoof

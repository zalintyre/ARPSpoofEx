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

The following command will use arpspoof to direct all traffic from the gateway to the victim and reverse over your interface. The IP Address of the router will be determined automatically.

* `./ARPSpoofEx.sh -i eth0 -v <IP Address>`

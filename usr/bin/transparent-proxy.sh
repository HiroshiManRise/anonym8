#!/bin/bash
### BEGIN INIT INFO
# Provides:          transparent-proxy
# Required-Start:    
# Required-Stop:     
# Default-Start:     
# Default-Stop:       
# Short-Description: Transparent proxy
# Description:       Transparent proxy for routing all traffic over Tor 
### END INIT INFO

#===============================================================================
#
#          FILE:  transparent-proxy
# 
#         USAGE:  ./transparent-proxy
# 
#   DESCRIPTION:  Routing Traffic over Tor for anonymizer pentesting
# 	Copyright (C) 2016 Teeknofil
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  Contact teeknofil-dev@gmail.com for bug.
#        AUTHOR:  Teeknofil 
#       COMPANY:  Anonymous freelance.
#       VERSION:  1.0
#       CREATED:  07/11/2017 05:42:31 CEST
#      REVISION:  ---
#===============================================================================

###########################
## debugging
###########################

#set -x 


#######
####### Global variable
#######

BOLD="\033[01;01m" # Higligh
BLUE='\033[1;94m'
GREEN='\e[0;32m'   # Success
YELLOW='\e[01;33m' # Warning/Information 
RED='\033[1;91m'   # Error
RESET="\033[00m"   # Normal

ColorEcho()
{
  echo -e "${1}${2}$RESET"  
}

OK=$(ColorEcho $GREEN "[ OK ]")
TASK=$(ColorEcho $GREEN "[+]")



###########################
## TOR_EXCLUDE
###########################

### set variables
#destinations you don't want routed through Tor
TOR_EXCLUDE="192.168.0.0/16 172.16.0.0/12 10.0.0.0/8"

###########################
## USERS
###########################

#the UID that Tor runs as (varies from system to system)
[ -n "$TOR_UID" ] || TOR_USER="$(id -u debian-tor)"

echo -e "\n$TASK $YELLOW Loading Transparent proxy firewall... $RESETCOLOR            \n";


###########################
## ports
###########################

## The following ports are used
##
## The following applications will be separated, preventing identity
## correlation through circuit sharing.

## Transparent Proxy Ports 
[ -n "$TOR_PORT" ] || TRANS_PORT="9040"
[ -n "$DNS_PORT" ] || DNS_PORT="53"

####################################
# Default Policies IPv4 OUTPUT     #
####################################


function forwarding {
		
	# set iptables nat
	iptables -t nat -A OUTPUT -m owner --uid-owner $TOR_UID -j RETURN
	## redirect all DNS traffic to TRANS_PORT	
	iptables -t nat -A OUTPUT -p udp --dport $DNS_PORT -j REDIRECT --to-ports $DNS_PORT
	iptables -t nat -A OUTPUT -p tcp --dport $DNS_PORT -j REDIRECT --to-ports $DNS_PORT
	iptables -t nat -A OUTPUT -p udp -m owner --uid-owner $TOR_UID -m udp --dport $DNS_PORT -j REDIRECT --to-ports $DNS_PORT
	
	# resolve .onion domains mapping 10.192.0.0/10 address space
	iptables -t nat -A OUTPUT -p tcp -d 10.192.0.0/10 -j REDIRECT --to-ports 9040
	iptables -t nat -A OUTPUT -p udp -d 10.192.0.0/10 -j REDIRECT --to-ports 9040
	## Exclude connections to local network from being redirected through Tor	
	# exclude local addresses
	for NET in $TOR_EXCLUDE 127.0.0.0/9 127.128.0.0/10; do
		iptables -t nat -A OUTPUT -d $NET -j RETURN
	done
	
	## redirect all other traffic through to TRANS_PORT TOR	
	iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports $TOR_PORT
	iptables -t nat -A OUTPUT -p udp -j REDIRECT --to-ports $TOR_PORT
	iptables -t nat -A OUTPUT -p icmp -j REDIRECT --to-ports $TOR_PORT

}



###########################
## IPv4 DEFAULTS
###########################

function IPv4_rules_table {


	######### Les instructions qui suivent concernent la table « filter » 
	######### Les politiques par défaut déterminent le devenir d'un paquet auquel
	######### aucune règle spécifique ne s'applique.


	echo -e "\n$TASK Policy rules                               : $YELLOW[ Start Initialization ]$RESETCOLOR\n"

	
	### Allow loopback
	## Traffic on the loopback interface is accepted.
	iptables -t filter -A INPUT  -i lo  -j ACCEPT	
	iptables -t filter -A OUTPUT -o lo  -j ACCEPT
	echo -e " $GREEN*$RESETCOLOR Allow loopback                                : $OK"

	### Allow PING
	iptables -t filter -A INPUT -p icmp -j ACCEPT
	

	
	#### Accept incoming packets relating to already established connections: 
	#### this goes faster than having to re-examine all the rules for each packet.
	#### Established incoming connections are accepted.
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	## Existing connections are accepted.
	iptables -A OUTPUT -m state --state ESTABLISHED,NEW -j ACCEP
	
	# exclude local addresses
	for NET in $TOR_EXCLUDE 127.0.0.0/8; do
		iptables -A OUTPUT -d $NET -j ACCEPT
	done
	
	# allow only tor output
	iptables -A OUTPUT -m owner --uid-owner $TOR_UID -j ACCEPT
	iptables -A OUTPUT -j REJECT

	#### Set secure defaults.

	## Reject anything not explicitly allowed above.
	## Drop is better than reject here, because we do not want to reveal it's a Linux.
	
	iptables -P INPUT DROP
	echo -e " $GREEN*$RESETCOLOR Block all connect INPUT                       : $OK"
	  
	## FORWARD rules does not actually do anything if forwarding is disabled. 
	##Better be safe just in case.
	iptables -P FORWARD DROP
	echo -e " $GREEN*$RESETCOLOR Block all connect FORWARD                     : $OK"
	  
	iptables -P OUTPUT DROP
	echo -e " $GREEN*$RESETCOLOR Block all connect OUTPUT                      : $OK"

	
	echo -e "\n $GREEN*$RESETCOLOR Policy by defaut                              : $OK"

}





function IPv6_rules_table {

	###########################
	## IPv6
	###########################

	## Policy DROP for all traffic as fallback.
	ip6tables -P INPUT DROP
	ip6tables -P OUTPUT DROP
	ip6tables -P FORWARD DROP

	## Flush old rules.
	ip6tables -F
	ip6tables -X
	ip6tables -t mangle -F
	ip6tables -t mangle -X

	## Allow unlimited access on loopback.
	## Not activated, since we do not need it.
	ip6tables -A INPUT -i lo -j ACCEPT
	ip6tables -A OUTPUT -o lo -j ACCEPT

	## Drop/reject all other traffic.
	ip6tables -A INPUT -j DROP
	## --reject-with icmp-admin-prohibited not supported by ip6tables
	ip6tables -A OUTPUT -j REJECT
	## --reject-with icmp-admin-prohibited not supported by ip6tables
	ip6tables -A FORWARD -j REJECT
}



################################# 
#                               #
#     		Main            #
#                               # 
#################################

forwarding
IPv4_rules_table
IPv6_rules_table

echo -e "·\n $GREEN*$RESETCOLOR Transparent proxy firewall loaded.                  : $OK"

echo -e "$RESETCOLOR"
exit 0

###########################
## End
###########################

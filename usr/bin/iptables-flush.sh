#!/bin/bash

#===============================================================================
#
#          FILE:  iptables-flush
#
#         USAGE:  iptables-flush
#
#   DESCRIPTION:  Clear Iptable
# 	Copyright (C) 2016 Teeknofil
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  Contact teeknofil-dev@gmail.com for bug.
#        AUTHOR:  Teeknofil
#       COMPANY:  Anonymous freelance.
#       VERSION:  1.0
#       CREATED:  18/07/2016 05:42:31 CEST
#      REVISION:  ---
#===============================================================================


	export BOLD='\033[01;01m'	# Highlight
	export BLUE='\033[1;94m'	# Info
	export GREEN='\033[1;92m'	# Success
	export RED='\033[1;91m'		# Issues/Errors
	export YELLOW='\033[01;33m'	# Warnings/Information	
	export RESETCOLOR='\033[1;00m'

	ColorEcho()
	{
	  echo -e "${1}${2}$RESET\n"
	}

	OK=$(ColorEcho $GREEN "[ OK ]")
	TASK=$(ColorEcho $GREEN "[+]")

	echo -e "$TASK Reset policy by default  \n";

	iptables -X
	iptables -F
	iptables -t filter -F
	iptables -t filter -X
	iptables -t nat -F
	iptables -t nat -X
	iptables -t mangle -F
	iptables -t mangle -X

	ip6tables -X
	ip6tables -F
	ip6tables -t filter -F
	ip6tables -t filter -X
	ip6tables -t nat -F
	ip6tables -t nat -X
	ip6tables -t mangle -F
	ip6tables -t mangle -X



	iptables --policy INPUT   ACCEPT
	iptables --policy FORWARD ACCEPT
	iptables --policy OUTPUT  ACCEPT

	ip6tables --policy INPUT   ACCEPT
	ip6tables --policy FORWARD ACCEPT
	ip6tables --policy OUTPUT  ACCEPT

	echo -e " $GREEN*$RESET Reset of firewall 				: $OK"
	echo -e $RESETCOLOR
exit 0

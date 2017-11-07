#!/bin/bash

#!/bin/bash

#=======================================================================
#
#          FILE:  INSTALL.sh
#
#         USAGE:  setup projet
#
#   DESCRIPTION:  Install script for anonym8
# 	Copyright (C) 2016 Teeknofil
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  Contact teeknofil.dev@gmail.com for bug.
#        AUTHOR:  Twitter: @HiroshimanRise#         
#        Thanks to:
#		teeknofil '@teeknofil'
#       COMPANY:  Anonymous freelance.
#       COMPANY:  Community Team Teeknofil.
#       VERSION:  2.0
#       CREATED:  
#      REVISION:  07/11/2017 03:42:31 CEST-
#=======================================================================


	export BLUE='\033[1;94m'
	export GREEN='\033[1;92m'
	export RED='\033[1;91m'
	export RESETCOLOR='\033[1;00m'
	
	if [ $(id -u) -ne 0 ]; then
			echo "[!] This script must be run as root!" >&2
			exit 1
	fi

	if [ -f usr/share/anonym8/banner.sh ] ; then
		
		/bin/bash usr/share/anonym8/banner.sh
	fi
	
	echo -e "\n$YELLOW$BOLD"
	echo -e "This script will install anonym8 on your computer...\n"
	echo -e " Press enter for continue of CTRL C for cancel$RESET"
	read
	sleep 1
	cp -Rf opt/anonym8 /opt/anonym8
	sleep 1
	cp -Rf anonym8.desktop /usr/share/applications
	sleep 1
	cp -Rf etc/anonym8.sh /etc/init.d/anonym8.sh
	sleep 1
	sleep 1
	cp -Rf usr/bin/* /usr/bin/
	sleep 1
	mkdir /usr/share/anonym8	
	cp -Rf usr/share/anonym8/* /usr/share/anonym8/
	## Check already program installing for speed setting
	apt-get update --fix-missing
	sleep 1
	if [ ! -f /usr/sbin/virt-what ]; then
		apt-get install -y virt-what
	fi
	sleep 1
	if [ ! -f /usr/bin/bleachbit ]; then
	sleep 1	apt-get install -y bleachbit
	fi
	sleep 1
	if [ ! -f /usr/bin/proxychains ]; then
		apt-get install -y proxychains
	fi
	sleep 1
	if [ ! -f /usr/bin/proxychains ]; then
		apt-get install -y pwnat
	fi
	sleep 1
	if [ ! -f /usr/bin/macchanger  ]; then
		apt-get install -y macchanger 
	fi
	sleep 1
	if [ ! -f /sbin/resolvconf  ]; then
		apt-get install -y resolvconf  
	fi
	sleep 1
	if [ ! -f /usr/sbin/dnsmasq  ]; then
		apt-get install -y dnsmasq   
	fi
	sleep 1
	if [ ! -f /usr/bin/polipo   ]; then
		apt-get install -y polipo    
	fi
	sleep 1
	if [ ! -f /usr/sbin/privoxy   ]; then
		apt-get install -y privoxy     
	fi
	sleep 1
	if [ ! -f /usr/share/python/runtime.d/tor-arm.rtupdate  ]; then
		apt-get install -y tor-arm     
	fi
	sleep 1
	if [ ! -f /usr/bin/libnotify-bin   ]; then
		apt-get install -y libnotify-bin     
	fi
	sleep 1
	if [ ! -f /usr/bin/curl    ]; then
		apt-get install -y curl      
	fi
	if [ ! -f /usr/sbin/tor  ]; then			
		apt-get install tor
			
	fi
	service tor restart
	## End APT
	
	cp -Rf etc/polipo/config /etc/polipo/config
	sleep 1
	cp -Rf etc/privoxy/config /etc/privoxy/config
	sleep 1
	cp -Rf etc/tor/torrc /etc/tor/torrc
	sleep 1
	chmod +x /etc/init.d/anonym8.sh /usr/bin/anonym8 /usr/bin/iptables-tor-router /usr/bin/iptables-flush /usr/bin/transparent-proxy /usr/bin/anON /usr/bin/anOFF /opt/anonym8/anonym8-gui /usr/share/anonym8/*
	sleep 1
	# USAGE ####
	updatedb
	if [ -f $(which helpers.sh) ] ; then
		
		/bin/bash /bin/bash usr/share/anonym8/ helpers.sh
	fi
	
echo -e $RESETCOLOR
exit 0

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
	echo -e " This script will install anonym8 on your computer...\n"
	echo -e " Press enter for continue of CTRL C for cancel$RESET"
	read
	sleep 0.5
	echo -e "\a"
	chmod +x /etc/init.d/anonym8.sh usr/bin/* /opt/anonym8/anonym8-gui /usr/share/anonym8/*
	sleep 0.5
	
	cp -Rf opt/anonym8 /opt/
	cp -Rf	var/lib/dbus/machine-id /var/lib/dbus/
	sleep 0.5
	
	cp -Rf anonym8.desktop /usr/share/applications
	sleep 0.5
	
	cp -Rf etc/anonym8.sh /etc/init.d/anonym8.sh
	sleep 0.5
	
	cp -Rf usr/bin/* /usr/bin/
	sleep 0.5
	
	mkdir -p /usr/share/anonym8
	cp -Rf usr/share/anonym8/* /usr/share/anonym8/
	
	## Check already program installing for speed setting
	apt-get update --fix-missing 
	sleep 0.5
	
	## Intall POLIPO
	if [ ! -f /usr/bin/polipo ]; then
		apt-get install -y polipo
		cp -Rf etc/polipo/config /etc/polipo/	
	else		
		cp -Rf etc/polipo/config /etc/polipo/    
	fi
	sleep 0.5

	## Intall Privoxy
	if [ ! -f /usr/sbin/privoxy   ]; then
		apt-get install -y privoxy
		cp -Rf etc/privoxy/config /etc/privoxy/  
	else
		cp -Rf etc/privoxy/* /etc/privoxy/       
	fi
	sleep 0.5
	
	## Intall Tor
	if [ ! -f /usr/sbin/tor ]; then	
		apt-get install -y tor
		cp -Rf etc/tor/* /etc/tor/	
	else
		cp -Rf etc/tor/* /etc/tor/
	fi
	sleep 0.5
	
	if [ ! -f /usr/sbin/virt-what ]; then
		apt-get install -y virt-what
	fi
	sleep 0.5

	if [ ! -f /usr/bin/bleachbit ]; then
		apt-get install -y bleachbit
	fi
	sleep 0.5
	
	if [ ! -f /usr/bin/proxychains ]; then
		apt-get install -y proxychains
	fi
	sleep 0.5
	
	if [ ! -f /usr/bin/proxychains ]; then
		apt-get install -y pwnat
	fi
	sleep 0.5
	
	if [ ! -f /usr/bin/macchanger  ]; then
		apt-get install -y macchanger 
	fi
	sleep 0.5
	
	if [ ! -f /sbin/resolvconf  ]; then
		apt-get install -y resolvconf  
	fi
	sleep 0.5
	
	#  Install dnsmasq
	if [ ! -f /usr/sbin/dnsmasq  ]; then
		apt-get install -y dnsmasq   
	fi
	sleep 0.5
		
	if [ ! -f /usr/share/python/runtime.d/tor-arm.rtupdate  ]; then
		apt-get install -y tor-arm     
	fi
	sleep 0.5
	
	if [ ! -f /usr/bin/libnotify-bin   ]; then
		apt-get install -y libnotify-bin     
	fi
	sleep 0.5
	
	if [ ! -f /usr/bin/curl    ]; then
		apt-get install -y curl      
	fi
	sleep 0.5	
	
	service tor restart
	
	## End APT
	
	echo -e "\n"
	# USAGE ####
	updatedb
	if [ -f $(which helpers.sh) ] ; then
		/bin/bash usr/share/anonym8/helpers.sh
	fi

echo -e "$RESETCOLOR"
exit 0

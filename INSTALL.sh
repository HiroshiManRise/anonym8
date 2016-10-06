#!/bin/bash
# Install script for anonym8

	export BLUE='\033[1;94m'
	export GREEN='\033[1;92m'
	export RED='\033[1;91m'
	export RESETCOLOR='\033[1;00m'

	echo -e "This script will install anonym8 on your computer...\n"
	sleep 1
	cp -Rf opt/anonym8 /opt/anonym8
	sleep 1
	cp -Rf anonym8.desktop /usr/share/applications
	sleep 1
	cp -Rf etc/anonym8.sh /etc/init.d/anonym8.sh
	sleep 1
	cp -Rf usr/anonym8 /usr/bin/anonym8
	sleep 1
	cp -Rf usr/anON /usr/bin/anON
	sleep 1
	cp -Rf usr/anOFF /usr/bin/anOFF
	sleep 1
	apt-get install tor macchanger resolvconf dnsmasq polipo privoxy tor-arm libnotify-bin curl bleachbit
	sleep 1
	cp -Rf polipo/config /etc/polipo/config
	sleep 1
	cp -Rf privoxy/config /etc/privoxy/config
	sleep 1
	cp -Rf tor/torrc /etc/tor/torrc
	sleep 1
	chmod +x /etc/init.d/anonym8.sh /usr/bin/anonym8 /usr/bin/anON /usr/bin/anOFF /opt/anonym8/anonym8-gui
	sleep 1
	echo -e "\n	 anonym8 (v 1.0) Usage Ex:\n
	$RED anON$BLUE  =>$GREEN automated protection [ON]
	$RED anOFF$BLUE =>$GREEN automated protection$RED [OFF]\n
	$RED ADVANCED COMMANDS LIST:\n
	$RED┌──[$GREEN$USER$RED@$BLUE`hostname`$RED]─[$GREEN$PWD$RED]
	$RED└──╼ $GREEN"anonym8" $RED{$GREEN"start"$RED|$GREEN"stop"$RED|$GREEN"change"$RED|$GREEN"status..."$RED}\n
	$BLUE----[ Tor Tunneling related features ]----
	$RED anonym8 start$BLUE            =>$GREEN Start Tor Tunneling	  
	$RED anonym8 stop$BLUE             =>$GREEN Stop Tor Tunneling
	$RED anonym8 change$BLUE           =>$GREEN Changes identity restarting TOR
	$RED anonym8 status$BLUE           =>$GREEN Tor Tunneling Status\n
	$BLUE----[ IP related features ]----
	$RED anonym8 status_ip$BLUE        =>$GREEN IP status\n
	$BLUE----[ I2P related features ]----
	$RED anonym8 start_i2p$BLUE        =>$GREEN Start i2p services
	$RED anonym8 stop_i2p$BLUE         =>$GREEN Stop i2p services
	$RED anonym8 status_i2p$BLUE       =>$GREEN i2p status\n
	$BLUE----[ privoxy related features ]----
	$RED anonym8 start_privoxy$BLUE    =>$GREEN Start privoxy services
	$RED anonym8 stop_privoxy$BLUE     =>$GREEN Stop privoxy services
	$RED anonym8 status_privoxy$BLUE   =>$GREEN privoxy status\n
	$BLUE----[ polipo related features ]----
	$RED anonym8 start_polipo$BLUE     =>$GREEN Start polipo services
	$RED anonym8 stop_polipo$BLUE      =>$GREEN Stop polipo services
	$RED anonym8 status_polipo$BLUE    =>$GREEN Polipo status\n
	$BLUE----[ macchanger related features ]----
	$RED anonym8 start_mac$BLUE        =>$GREEN Start macchanger services
	$RED anonym8 stop_mac$BLUE         =>$GREEN Stop macchanger services
	$RED anonym8 status_mac$BLUE       =>$GREEN macchanger status\n
	$BLUE----[ arm related features ]----
	$RED anonym8 start_arm$BLUE        =>$GREEN Start Monitoring Anonymizing Relay (arm)\n
	$BLUE----[ wipe related features ]----
	$RED anonym8 wipe$BLUE             =>$GREEN cache, RAM & swap-space cleaner\n
	$BLUE----[ hostname related features ]----
	$RED anonym8 change_hostname$BLUE  =>$GREEN Randomly Spoofing Hostname
	$RED anonym8 restore_hostname$BLUE =>$GREEN Restore Default Hostname
	$RED anonym8 status_hostname$BLUE  =>$GREEN Show Current Hostname\n

	$RESETCOLOR"

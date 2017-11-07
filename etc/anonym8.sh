#!/bin/bash

#===============================================================================
#
#          FILE:  Anonym8
#
#         USAGE:  anonym8 start|stop|change|status
#
#   DESCRIPTION:  This code is based on anonsurf by #ParrotSec & AnonSecTunnel by cysec666 #AnonSec 
#                 implementing TOR, I2P, Privoxy, Polipo, arm-tor and MacChanger for a simple and better privacy and # #                 security.	
# Short-Description: Transparent Proxy through TOR, I2P, Privoxy, Polipo + arm-tor and MacChanger features virt-what
# 	Copyright (C) 2016 Coded by Hiroshiman
#       OPTIONS:  ---
#  REQUIREMENTS:Tor macchanger resolvconf dnsmasq polipo privoxy arm libnotify curl bleachbit
#          BUGS:  ---
#         NOTES:  Contact teeknofil.dev@gmail.com for bug.
#         AUTHOR:  Twitter: @HiroshimanRise
#         Thanks to:
#		cysec666 '@cysec666'
#		teeknofil '@teeknofil'
#		Lorenzo 'EclipseSpark' Faletra <eclipse@frozenbox.org>
# 		Lisetta 'Sheireen' Ferrero <sheireen@frozenbox.org>
# 		Francesco 'mibofra'/'Eli Aran'/'SimpleSmibs' Bonanno <mibofra@ircforce.tk> <mibofra@frozenbox.org>
#       COMPANY:  Community Team teeknofil.
#       VERSION:  1.1
#       CREATED:  
#      REVISION:  07/11/2017 03:42:31 CEST---
#===============================================================================
# Feel free to edit and share this script ;)
### BEGIN INIT INFO
# Provides: Anonym8
# Short-Description: Transparent Proxy through TOR, I2P, Privoxy, Polipo + arm-tor and MacChanger features
### END INIT INFO





export BOLD='\033[01;01m'	# Highlight
export BLUE='\033[1;94m'	# Info
export GREEN='\033[1;92m'	# Success
export RED='\033[1;91m'		# Issues/Errors
export YELLOW='\033[01;33m'	# Warnings/Information	
export RESETCOLOR='\033[1;00m'
export notify

ColorEcho()
{
  echo -e "${1}${2}$RESET"  
}

OK=$(ColorEcho $GREEN "[ OK ]")
TASK=$(ColorEcho $GREEN "[+]")

# Destinations you don't want routed through Tor
TOR_EXCLUDE="192.168.0.0/16 172.16.0.0/12 10.0.0.0/8"

# The UID Tor runs as
# change it if, starting tor, the command 'ps -e | grep tor' returns a different UID
TOR_UID="debian-tor"

# Tor's TransPort
TOR_PORT="9040"

# List, separated by spaces, of process names that should be killed
TO_KILL="chrome chromium transmission dropbox iceweasel icedove firefox firefox-esr pidgin pidgin.orig skype deluge thunderbird xchat dnsmasq"

# List, separated by spaces, of BleachBit cleaners
BLEACHBIT_CLEANERS="bash.history system.cache system.clipboard system.custom system.recent_documents system.rotated_logs system.tmp system.trash adobe_reader.cache chromium.cache chromium.current_session chromium.history elinks.history emesene.cache epiphany.cache firefox.url_history flash.cache flash.cookies google_chrome.cache google_chrome.history  links2.history opera.cache opera.search_history opera.url_history"

# Overwrite files to hide contents
OVERWRITE="true"
#Proxy

ftp_proxy="127.0.0.1:9050" 
http_proxy="127.0.0.1:9050"
https_proxy="127.0.0.1:9050"
socks_proxy="127.0.0.1:9050"
# Persistant proxychains
# eg : nmap -sT  -p 22 scanme.nmap.org
# TO DO
# Fix Me -> reset default value
LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libproxychains.so.3"  

### FUNCTIONS ####

################################# 
#                               #
#      Divers	                #
#                               # 
#################################

function warning {
	echo -e " $GREEN[$RED!$GREEN]$RESETCOLOR Warning ! \n"
	echo " This script simply avoids the most common data leakage in the system."
	echo " What you are doing is allowing you to remain anonymous"
	echo " Do not do stupid things".
	echo
	echo -e "  $GREEN[$RED!$GREEN]$RESETCOLOR Edit /etc/default/transparent-proxy.sh for your firewall ! ! ! \n"
}

## notify ####
function notify {
	if [ -e /usr/bin/notify-send ]; then
		/usr/bin/notify-send "anonym8" "$1"
	fi
}

## Make sure that only root can run this script
function check_root {
	if [ $(id -u) -ne 0 ]; then
		echo -e "\n$GREEN[$RED!$GREEN]$RED This script must be run as root$RESETCOLOR" >&2
		exit 1
	fi
}

# General-purpose Yes/No prompt function
function ask {
	while true; do
		if [ "${2:-}" = "Y" ]; then
			prompt="Y/n"
			default=Y
		elif [ "${2:-}" = "N" ]; then
			prompt="y/N"
			default=N
		else
			prompt="y/n"
			default=
		fi

		# Ask the question
		echo
		read -p "$1 [$prompt] > " REPLY

		# Default?
		if [ -z "$REPLY" ]; then
			REPLY=$default
		fi

		# Check if the reply is valid
		case "$REPLY" in
			Y*|y*) return 0 ;;
			N*|n*) return 1 ;;
		esac
	done
}

## wipe ####
function wipe {
	echo -e "\n$GREEN*$BLUE now wiping cache, ram, & swap-space...\n"
	sync; echo 3 > /proc/sys/vm/drop_caches
	swapoff -a && swapon -a
	sleep 1
	echo -e "$GREEN*$BLUE Cache, ram & swap-space$GREEN [CLEANED]"$RESETCOLOR
	notify "Cache, ram & swap-space cleaned!"
}

## ARM ####
function start_arm {
	echo -e "\n$GREEN*$BLUE Starting Anonymizing Relay Monitor (arm)..."$RESETCOLOR
	xhost +
	sleep 1
	DISPLAY=:0.0 gnome-terminal -e "sudo arm"
	sleep 1
}

################################# 
#                               #
#      Privacy	                #
#                               # 
#################################

# Kill processes at startup
function kill_process {
	if [ "$TO_KILL" != "" ]; then
		killall -q $TO_KILL
		echo -e "\n$GREEN*$BLUE Killing dangerous applications and cleaning some cache elements...\n"$RESETCOLOR
	fi
}

# BleachBit cleaners deletes unnecessary files to preserve privacy
function bleachbit {
	if [ "$OVERWRITE" = "true" ] ; then
		echo -e " $GREEN*$RESETCOLOR Deleting unnecessary files ... "
		bleachbit -o -c $BLEACHBIT_CLEANERS >/dev/null
	else
		echo -e " $GREEN*$RESETCOLOR Deleting unnecessary files ... "
		bleachbit -c $BLEACHBIT_CLEANERS >/dev/null
	fi
	sleep 1
	echo -e "$GREEN*$BLUE Dangerous applications$GREEN [KILLED]\n"
	echo "Done!"
}

################################# 
#                               #
#      Iptables	                #
#                               # 
#################################

function iptables_tor {
	updatedb
	if [ -f $(which transparent-proxy.sh) ] ; then		
		/bin/bash $(which transparent-proxy.sh)
	fi

	service tor restart
}

function iptables_flush {
	updatedb
	if [ -f $(which iptables-flush.sh ] ; then
		/bin/bash $(which iptables-flush.sh)
	fi
}

# Implementation of Transparently Routing Traffic Through Tor
# https://trac.torproject.org/projects/tor/wiki/doc/TransparentProxy
function transparent_proxy {	


	if [ ! -e /var/run/tor/tor.pid ]; then
	echo -e "$GREEN*$BLUE starting Tor...\n" >&2
		sleep 1
		service resolvconf stop
		killall dnsmasq
		sleep 2
		service tor start
		sleep 6
	fi
	
	if ! [ -f /etc/network/iptables.rules ]; then
		iptables-save > /etc/network/iptables.rules
		echo -e "$GREEN*$BLUE Saving iptables.rules...$RESETCOLOR\n"
		sleep 2
	fi	
	
	iptables_flush
	echo -e "$GREEN*$BLUE iptables.rules$GREEN [SAVED]\n"	
	
	echo -e "$GREEN*$BLUE Saving resolv.conf...\n"
	cp /etc/resolv.conf /etc/resolv.conf.bak
	touch /etc/resolv.conf
	sleep 2
	echo -e "$GREEN*$BLUE resolv.conf$GREEN [SAVED]\n"
	sleep 2
	echo -e "$GREEN*$BLUE Modifying DNS...\n"
	sleep 2
	echo -e 'nameserver 127.0.0.1\nnameserver 213.73.91.35\nnameserver 87.118.100.175' > /etc/resolv.conf
	echo -e "$GREEN*$BLUE resolv.conf: Chaos Computer Club & German Privacy Foundation DNS$GREEN [ACTIVATED]\n"$RESETCOLOR        
	sleep 2
	#Kill IPv6 services
	echo -e " $GREEN[$BLUE i$GREEN ]$RESET Stopping IPv6 services \n"
	# add lines to sysctl.conf that will kill ipv6 services
	echo "net.ipv6.conf.all.disable_ipv6 = 1 " >> /etc/sysctl.conf
	echo "net.ipv6.conf.default.disable_ipv6=1 " >> /etc/sysctl.conf
	sysctl -p > /dev/null # have sysctl reread /etc/sysctl.conf
	iptables_tor
	
	#Anonymous Proxy
	export ftp_proxy  
	export http_proxy
	export https_proxy
	export socks_proxy
	export LD_PRELOAD 
	
	echo -e "$GREEN*$BLUE Tor Tunneling$GREEN [ON]"$RESETCOLOR 
	sleep 1
	notify "Tor Tunneling ON"  
}

################################# 
#                               #
#      Hostname	                #
#                               # 
#################################

# Change the local hostname

# change ####
function change_hostname {
	cp /etc/hostname /etc/hostname.bak
	cp /etc/hosts /etc/hosts.bak
	sudo service network-manager stop
	CURRENT_HOSTNAME=$(hostname)
	clean_DHCP true
	RANDOM_HOSTNAME=$(shuf -n 1 /etc/dictionaries-common/words | sed -r 's/[^a-zA-Z]//g' | awk '{print tolower($0)}')
	NEW_HOSTNAME=${1:-$RANDOM_HOSTNAME}
	echo "$NEW_HOSTNAME" > /etc/hostname
	sed -i 's/127.0.1.1.*/127.0.1.1\t'"$NEW_HOSTNAME"'/g' /etc/hosts
	
	if [ -f "$HOME/.Xauthority" ] ; then
		su "$SUDO_USER" -c "xauth -n list | grep -v $CURRENT_HOSTNAME | cut -f1 -d\ | xargs -i xauth remove {}"
		su "$SUDO_USER" -c "xauth add $(xauth -n list | tail -1 | sed 's/^.*\//'$NEW_HOSTNAME'\//g')"
		echo " * X authority file updated"
	fi
	
	sudo service network-manager start
	sleep 5
	echo -e -n "\n$GREEN*$BLUE New Hostname: $GREEN"
	hostname
	notify "hostname spoofed"
}

# restore ####
function restore_hostname {
	sudo service network-manager stop
	clean_DHCP true
	if [ -e /etc/hostname.bak ]; then
		rm /etc/hostname
		cp /etc/hostname.bak /etc/hostname
	fi
	if [ -e /etc/hosts.bak ]; then
		rm /etc/hosts
		cp /etc/hosts.bak /etc/hosts
	fi
	sudo service network-manager start
	sleep 5
	echo -e -n "\n$GREEN*$BLUE Restored Hostname: $GREEN"
	hostname 
	notify "hostname restored"
}

function custom_hostname {

	CURRENT_HOSTNAME=$(hostname)
	RANDOM_HOSTNAME=$(shuf -n 1 /etc/dictionaries-common/words | sed -r 's/[^a-zA-Z]//g' | awk '{print tolower($0)}')
	NEW_HOSTNAME=${1:-$RANDOM_HOSTNAME}
	echo $NEW_HOSTNAME > /etc/hostname
	sed -i 's/127.0.0.1.*/127.0.0.1\t'$NEW_HOSTNAME'/g' /etc/hosts
	echo -e " $GREEN*$RESET Change the hostname to $NEW_HOSTNAME"
}

# status ####
function status_hostname {
	echo -e -n "\n$GREEN*$BLUE Current Hostname: $GREEN"
	hostname
}




################################# 
#                               #
#      PRIVOXY                  #
#                               # 
#################################
# START ####
function start_privoxy {
	echo -e "\n$GREEN*$BLUE Starting Privoxy Service...\n"$RESETCOLOR       
	sleep 1
	sudo service privoxy start
	echo -e "$GREEN*$BLUE Privoxy Service$GREEN [ON]"$RESETCOLOR
	sleep 1
	notify "Privoxy daemon ON"
}

# STOP ####
function stop_privoxy {
	echo -e "\n$GREEN*$BLUE Stopping Privoxy Service...\n"$RESETCOLOR
	sleep 1
	sudo service privoxy stop
	sleep 1
	echo -e "$GREEN*$BLUE Privoxy Service$RED [OFF]"$RESETCOLOR
	sleep 1
	notify "Privoxy daemon OFF" 
}

# STATUS ####
function status_privoxy {
	echo -e "\n$GREEN*$BLUE Privoxy Service Status:\n"$RESETCOLOR
	sleep 1
	sudo service privoxy status
	sleep 1
}



################################# 
#                               #
#      POLIPO                   #
#                               # 
#################################

# START ####
function start_polipo {
	echo -e "\n$GREEN*$BLUE Starting Polipo Service...\n"$RESETCOLOR      
	sleep 1
	sudo service polipo start
	echo -e "$GREEN*$BLUE Polipo Service$GREEN [ON]"$RESETCOLOR
	sleep 1
	notify "Polipo daemon ON" 
}

# STOP ####
function stop_polipo {
	echo -e "\n$GREEN*$BLUE Stopping Polipo Service...\n"$RESETCOLOR
	sleep 1
	sudo service polipo stop
	sleep 1
	echo -e "$GREEN*$BLUE Polipo Service$RED [OFF]"$RESETCOLOR
	sleep 1
	notify "Polipo daemon OFF"  
}

# STATUS ####
function status_polipo {
	echo -e "\n$GREEN*$BLUE Polipo Service Status:\n"$RESETCOLOR
	sleep 1
	sudo service polipo status
	sleep 1
}

################################# 
#                               #
#      MACCHANGER               #
#                               # 
#################################


## Change the MAC address for network interfaces
start_mac ()
{
	echo -e "Select network interfaces : "
	read IFACE
	sleep 0.5
	sudo service network-manager stop
	sleep 0.5
	echo -e "$GREEN*$BLUE $IFACE MAC address:\n"$GREEN	
	sleep 0.5
	ifconfig  $IFACE down
	
	
	
	if [ "$1" = "permanent" ]; then

		NEW_MAC=$(macchanger -p "$IFACE" )
		echo "$NEW_MAC"
	else
		NEW_MAC=$(macchanger -A "$IFACE" )
		echo "$NEW_MAC"
	fi
	
	sleep 0.5
	sudo ifconfig $IFACE up
	sleep 0.5
	sudo service network-manager start
	sleep 0.5
	dhclient 
}


# START ####
function spoofing_wlan0_mac {
	echo -e "\n$GREEN*$BLUE Spoofing Mac Address...\n"
	sudo service network-manager stop
	sleep 1
	echo -e "$GREEN*$BLUE wlan0 MAC address:\n"$GREEN
	sleep 1
	sudo ifconfig wlan0 down
	sleep 1
	sudo macchanger -a wlan0
	sleep 1
	sudo ifconfig wlan0 up
	sleep 1
	sudo service network-manager start
	echo -e "\n$GREEN*$BLUE Mac Address Spoofing$GREEN [ON]"$RESETCOLOR
	sleep 1
	notify "Mac Address Spoofing ON" 
}

# STOP ####
function stop_mac {
	echo -e "\n$GREEN*$BLUE Restoring Mac Address...\n"
	sudo service network-manager stop
	sleep 1
	echo -e "$GREEN*$BLUE wlan0 MAC address:\n"$GREEN	
	sleep 1
	sudo ifconfig wlan0 down
	sleep 1
	sudo macchanger -p wlan0
	sleep 1
	sudo ifconfig wlan0 up
	sleep 1
	sudo service network-manager start
	sleep 1
	echo -e "\n$GREEN*$BLUE Mac Address Spoofing$RED [OFF]"$RESETCOLOR
	sleep 1
	notify "Mac Address Spoofing OFF" 
}

# STATUS ####
function status_mac {
	echo -e "\n$GREEN*$BLUE Mac Adress Status:\n"
	sleep 1
	echo -e "$GREEN*$BLUE wlan0 Mac Adress:\n"$GREEN
	sleep 1
	macchanger wlan0
	sleep 1
}

################################# 
#                               #
#      I2P                      #
#                               # 
#################################

# START ####
function start_i2p {
	echo -e "\n$GREEN*$BLUE starting I2P service\n"$RESETCOLOR
	anonym8 stop
	sleep 4
	cp /etc/resolv.conf /etc/resolv.conf.bak
	touch /etc/resolv.conf
	echo -e 'nameserver 127.0.0.1\nnameserver 213.73.91.35\nnameserver 87.118.100.175' > /etc/resolv.conf
	echo -e "\n$GREEN*$BLUE resolv.conf: Chaos Computer Club & German Privacy Foundation$GREEN [ACTIVATED]\n"$RESETCOLOR        
	sleep 1
	sudo -u i2psvc i2prouter start
	sleep 1
	echo -e "$GREEN*$BLUE I2P Service$GREEN [ON]"$RESETCOLOR
	sleep 1
	notify "I2P Daemon ON"  
}

# STOP ####
function stop_i2p {
	echo -e "\n$GREEN*$BLUE stop I2P service\n"$GREEN
	sleep 1
	sudo -u i2psvc i2prouter stop
	if [ -e /etc/resolv.conf.bak ]; then
		rm /etc/resolv.conf
		cp /etc/resolv.conf.bak /etc/resolv.conf
	fi
	sleep 1
	echo -e "\n$GREEN*$BLUE I2P Service$RED [OFF]"$RESETCOLOR
	sleep 1
	notify "I2P Daemon OFF" 
}

# STATUS ####
function status_i2p {
	echo -e "\n$GREEN*$BLUE I2P Service Status:\n"$GREEN
	sleep 1
	sudo -u i2psvc i2prouter status
	sleep 1
}

################################# 
#                               #
#      IP                       #
#                               # 
#################################

function status_ip {

	echo -e -n "\n$GREEN*$BLUE Current Proxy IP: $GREEN"	
	IP=$(curl -s https://check.torproject.org/?lang=en_US | egrep -m1 -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
	sleep 1	
	HTML=$(curl -s https://check.torproject.org/?lang=en_US)	
	echo $HTML | grep -q "$BLUE Congratulations. This shell is configured to use Tor."
	sleep 1
	if [ ! $? -ne 0 ]; then	
		echo  -e " $GREEN*$RESETCOLOR IP $IP"
		echo -e " $GREEN*$RESETCOLOR Tor ON"
		exit $?
	else
		echo -e " $GREEN*$RESETCOLOR IP $IP"
		echo -e " $GREEN*$RESETCOLOR Tor OFF"
		exit $?
	fi
}

function clean_DHCP
{
	dhclient -r
	
	if [ "$OVERWRITE" = "true" ] ; then
		rm -f /var/lib/dhcp/dhclient*
	fi
	
	echo -e " $GREEN*$RESET We release the DHCP address"
}

################################# 
#                               #
#     Main                      #
#                               # 
#################################

## START ####
function start {
		
	# Make sure only root can run our script
	check_root
	warning
	# feel free to add your own internet connected app
	kill_process
	sleep 1
	
	if ask "Delete unnecessary files to preserve your privacy?" Y; then
		bleachbit
	fi	 
	sleep 1	
	
	if Ask "You want to make a transparent routing traffic through Tor?" Y; then
		transparent_proxy
		echo -e "$TASK  All traffic was redirected throught Tor 	: $OK\n"			
	fi		
	sleep 1	
	
	if [ "$(virt-what)" != "" ]; then
		echo " $GREEN*$RESET Unable to change MAC address in a Virtual Machine"
	else
		if Ask "Do you want to change the MAC address?" Y; then
			start_mac
		fi
	fi
	
	if ask "Do you want to change the local hostname?" Y; then
		read -p "Type it or press Enter for a random one > " CHOICE

		if [ "$CHOICE" = "" ]; then
			change_hostname
		else
			custom_hostname "$CHOICE"
		fi
	fi
}

## STOP ####
function stop {
	# Make sure only root can run our script
	check_root
	# feel free to add your own internet connected app
	kill_process
	sleep 1
	
	if ask "Delete unnecessary files to preserve your privacy?" Y; then
		bleachbit
	fi
		
	iptables_flush
	
	sleep 2
	echo -e "$GREEN*$BLUE Restoring iptables.rules...$RESETCOLOR\n"
	sleep 2
	
	if [ -f /etc/network/iptables.rules ]; then
		iptables-restore < /etc/network/iptables.rules
		rm /etc/network/iptables.rules
	sleep 1
	echo -e "$GREEN*$BLUE iptables.rules$GREEN [RESTORED]\n"
	sleep 2
	fi
	
	echo -e "$GREEN*$BLUE Restoring resolv.conf...\n"
	if [ -e /etc/resolv.conf.bak ]; then
		rm /etc/resolv.conf
		cp /etc/resolv.conf.bak /etc/resolv.conf
	fi
	
	unset ftp_proxy  
	unset http_proxy
	unset https_proxy
	unset socks_proxy 
	unset LD_PRELOAD
	
	if [ "$(virt-what)" != "" ]; then
		echo " $GREEN*$RESETCOLOR We can not change the MAC address on a virtual machine"
	else
		if ask "You want to change your MAC address?" Y; then
			if ask "You want to change your MAC address permanent?" Y; then
				start_mac permanent			
			else
				start_mac 
			fi
		fi
	fi
	
	
	if ask "You want to change your local hostname?" Y; then
		read -p "Write it, or press Enter to use your  > " CHOICE

		if [ "$CHOICE" = "" ]; then
			restore_hostname
		else
			custom_hostname $CHOICE
		fi
	fi
	
	
	echo -e "$GREEN*$BLUE resolv.conf$GREEN [RESTORED]\n"
	sleep 2
	echo -e "$GREEN*$BLUE Stopping Tor...\n"
	service tor stop
	sleep 4
	echo -e "$GREEN*$BLUE Restarting Services...\n"
	service resolvconf start
	service dnsmasq start
	echo -e "$GREEN*$BLUE Services Successfully$GREEN [RELOADED]\n"
	sleep 3
	echo -e "$GREEN*$BLUE Tor Tunneling$RED [OFF]"$RESETCOLOR 
	sleep 1
	notify "Tor Tunneling OFF"
}

## CHANGE ####
function change {
	echo -e "\n$GREEN*$BLUE Changing Tor Relay...\n"$RESETCOLOR 
	service tor reload
	sleep 4
	echo -e "$GREEN*$BLUE Change Identity$GREEN [SUCCESS]\n" 
	sleep 1
	echo -e -n "$GREEN*$BLUE Current Proxy IP: $GREEN"
	curl icanhazip.com
	sleep 1
	echo -e "\n$GREEN*$BLUE Current Tor IP:\n"$GREEN
	sleep 1
	curl -s https://check.torproject.org/?lang=en_US | egrep -m1 -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
	sleep 1
	notify "Tor Relay Changed" 
	if [ "$(virt-what)" != "" ]; then
		echo " $GREEN*$RESETCOLOR We can not change the MAC address on a virtual machine"
	else
		if ask "You want to change your MAC address?" Y; then
			if ask "You want to change your MAC address permanent?" Y; then
				start_mac permanent			
			else
				start_mac 
			fi
		fi
	fi 
	notify "Mac Address Changed"
}

## STATUS ####
function status {
	echo -e "\n$GREEN*$BLUE Tor Tunneling Status:\n"$RESETCOLOR
	service tor status
	CURRENT_HOSTNAME=$(hostname)
	echo -e " $GREEN*$RESETCOLOR Hostname $CURRENT_HOSTNAME" 
}



### CASE ####

case "$1" in
	status_hostname)
		status_hostname
	;;
	change_hostname)
		change_hostname
	;;
	restore_hostname)
		restore_hostname
	;;
	start)
		start
	;;
	stop)
		stop
	;;
	change)
		change
	;;
	status)
		status
	;;
	status_ip)
		status_ip
	;;
	start_i2p)
		start_i2p
	;;
	stop_i2p)
		stop_i2p
	;;
	status_i2p)
		status_i2p
	;;
	start_privoxy)
		start_privoxy
	;;
	stop_privoxy)
		stop_privoxy
	;;
	status_privoxy)
		status_privoxy
	;;	
	start_polipo)
		start_polipo
	;;
	stop_polipo)
		stop_polipo
	;;
	status_polipo)
		status_polipo
	;;
	spoofing_wlan0_mac)
		spoofing_wlan0_mac
	;;
	stop_mac)
		stop_mac
	;;
	status_mac)
		status_mac
	;;
	start_arm)
		start_arm
	;;
	wipe)
		wipe
	;;
   *)
# USAGE ####
	updatedb
	if [ -f $(which helpers.sh) ] ; then
		
		/bin/bash $(which helpers.sh)
	fi

	$RESETCOLOR" >&2
exit 1
;;
esac

echo -e $RESETCOLOR
exit 0

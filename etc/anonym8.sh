#!/bin/bash

# This code is based on anonsurf by #ParrotSec & AnonSecTunnel by cysec666 #AnonSec
# implementing TOR, I2P, Privoxy, Polipo, arm-tor and MacChanger for a simple and better privacy and security.

# Coded by Hiroshiman
# Twitter: @HiroshimanRise

### BEGIN INIT INFO
# Provides: Anonym8
# Short-Description: Transparent Proxy through TOR, I2P, Privoxy, Polipo + arm-tor and MacChanger features
### END INIT INFO

# Thanks to:
# cysec666 '@cysec666'
# Lorenzo 'EclipseSpark' Faletra <eclipse@frozenbox.org>
# Lisetta 'Sheireen' Ferrero <sheireen@frozenbox.org>
# Francesco 'mibofra'/'Eli Aran'/'SimpleSmibs' Bonanno <mibofra@ircforce.tk> <mibofra@frozenbox.org>

# Feel free to edit and share this script ;)

export BLUE='\033[1;94m'
export GREEN='\033[1;92m'
export RED='\033[1;91m'
export RESETCOLOR='\033[1;00m'
export notify

# Destinations you don't want routed through Tor
TOR_EXCLUDE="192.168.0.0/16 172.16.0.0/12 10.0.0.0/8"

# The UID Tor runs as
# change it if, starting tor, the command 'ps -e | grep tor' returns a different UID
TOR_UID="debian-tor"

# Tor's TransPort
TOR_PORT="9040"

### FUNCTIONS ####

## notify ####
function notify {
	if [ -e /usr/bin/notify-send ]; then
		/usr/bin/notify-send "anonym8" "$1"
	fi
}

## hostname ####

# change ####
function change_hostname {
	cp /etc/hostname /etc/hostname.bak
	cp /etc/hosts /etc/hosts.bak
	sudo service network-manager stop
	CURRENT_HOSTNAME=$(hostname)
	dhclient -r
	rm -f /var/lib/dhcp/dhclient*
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
	dhclient -r
	rm -f /var/lib/dhcp/dhclient*
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

# status ####
function status_hostname {
	echo -e -n "\n$GREEN*$BLUE Current Hostname: $GREEN"
	hostname
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

## PRIVOXY ####

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

## POLIPO ####

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

## MACCHANGER ####

# START ####
function start_mac {
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

## I2P ####

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

## IP ####
function status_ip {
	echo -e -n "\n$GREEN*$BLUE Current Proxy IP: $GREEN"
	curl icanhazip.com
	sleep 1
	echo -e "\n$GREEN*$BLUE Current Tor IP:\n"$GREEN
	sleep 1
	curl ipinfo.io/
	sleep 1
}

## START ####
function start {
	# Make sure only root can run this script
	if [ $(id -u) -ne 0 ]; then
		echo -e "\n$GREEN[$RED!$GREEN]$RED This script must be run as root$RESETCOLOR" >&2
		exit 1
	fi
	
	echo -e "\n$GREEN*$BLUE Killing dangerous applications and cleaning some cache elements...\n"$RESETCOLOR
	sleep 1
	killall -q chrome dropbox iceweasel skype icedove thunderbird firefox-esr firefox chromium xchat transmission kvirc pidgin hexchat # feel free to add your own internet connected app
	sleep 1
	bleachbit -c adobe_reader.cache chromium.cache chromium.current_session chromium.history elinks.history emesene.cache epiphany.cache firefox.url_history flash.cache flash.cookies google_chrome.cache google_chrome.history  links2.history opera.cache opera.search_history opera.url_history &> /dev/null
	sleep 1
	echo -e "$GREEN*$BLUE Dangerous applications$GREEN [KILLED]\n"
	sleep 1
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
	iptables -F
	iptables -t nat -F
	echo -e "$GREEN*$BLUE iptables.rules$GREEN [SAVED]\n"
	sleep 2
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

	# set iptables nat
	iptables -t nat -A OUTPUT -m owner --uid-owner $TOR_UID -j RETURN
	iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 53
	iptables -t nat -A OUTPUT -p tcp --dport 53 -j REDIRECT --to-ports 53
	iptables -t nat -A OUTPUT -p udp -m owner --uid-owner $TOR_UID -m udp --dport 53 -j REDIRECT --to-ports 53
	
	# resolve .onion domains mapping 10.192.0.0/10 address space
	iptables -t nat -A OUTPUT -p tcp -d 10.192.0.0/10 -j REDIRECT --to-ports 9040
	iptables -t nat -A OUTPUT -p udp -d 10.192.0.0/10 -j REDIRECT --to-ports 9040
	
	# exclude local addresses
	for NET in $TOR_EXCLUDE 127.0.0.0/9 127.128.0.0/10; do
		iptables -t nat -A OUTPUT -d $NET -j RETURN
	done
	
	# redirect all other output through TOR
	iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports $TOR_PORT
	iptables -t nat -A OUTPUT -p udp -j REDIRECT --to-ports $TOR_PORT
	iptables -t nat -A OUTPUT -p icmp -j REDIRECT --to-ports $TOR_PORT
	
	# accept already established connections
	iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	
	# exclude local addresses
	for NET in $TOR_EXCLUDE 127.0.0.0/8; do
		iptables -A OUTPUT -d $NET -j ACCEPT
	done
	
	# allow only tor output
	iptables -A OUTPUT -m owner --uid-owner $TOR_UID -j ACCEPT
	iptables -A OUTPUT -j REJECT

	echo -e "$GREEN*$BLUE Tor Tunneling$GREEN [ON]"$RESETCOLOR 
	sleep 1
	notify "Tor Tunneling ON"  
}

## STOP ####
function stop {
	# Make sure only root can run our script
	if [ $(id -u) -ne 0 ]; then
		echo -e "\n$GREEN[$RED!$GREEN]$RED This script must be run as root\n" >&2
		exit 1
	fi
	echo -e "\n$GREEN*$BLUE killing dangerous applications and cleaning some cache elements...\n"$RESETCOLOR
	killall -q chrome dropbox iceweasel skype icedove thunderbird firefox-esr firefox chromium xchat transmission kvirc pidgin hexchat # feel free to add your own internet connected app
	sleep 1
	bleachbit -c adobe_reader.cache chromium.cache chromium.current_session chromium.history elinks.history emesene.cache epiphany.cache firefox.url_history flash.cache flash.cookies google_chrome.cache google_chrome.history  links2.history opera.cache opera.search_history opera.url_history &> /dev/null
	sleep 1
	echo -e "$GREEN*$BLUE Dangerous applications$GREEN [KILLED]\n"
	sleep 1
	iptables -F
	iptables -t nat -F
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
	curl ipinfo.io/
	sleep 1
	notify "Tor Relay Changed"  
}

## STATUS ####
function status {
	echo -e "\n$GREEN*$BLUE Tor Tunneling Status:\n"$RESETCOLOR
	service tor status 
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
	start_mac)
		start_mac
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
	echo -e "	 anonym8 (v 1.0) Usage Ex:\n
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

	$RESETCOLOR" >&2
exit 1
;;
esac

echo -e $RESETCOLOR
exit 0

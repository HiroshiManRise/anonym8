#!/bin/sh

#===============================================================================
#
#          FILE:  iptables-tor-router.sh
#
#         USAGE:  ./iptables-tor-router.sh
#
#   DESCRIPTION:  Routing Traffic over Tor
#       Copyright (C) 2016 Teeknofil
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

### set variables

#the UID that Tor runs as (varies from system to system)
[ -n "$TOR_USER" ] || TOR_USER="$(id -u debian-tor)"

#Tor's TransPort
TOR_PORT="9040"

#Tor's DNSPort
DNS_PORT="53"

#Tor's VirtualAddrNetworkIPv4
_virt_addr="10.192.0.0/10"

#your outgoing and incoming interfaces
_out_if_1="eth0"
_out_if_2="wlan1"
_inc_if="wlan0"


### Don't lock yourself out after the flush
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT

### flush iptables
iptables -F
iptables -t nat -F

### https://lists.torproject.org/pipermail/tor-talk/2014-March/032503.html
iptables -A OUTPUT ! -o lo ! -d 127.0.0.1 ! -s 127.0.0.1 -p tcp -m tcp --tcp-flags ACK,FIN ACK,FIN -j DROP
iptables -A OUTPUT ! -o lo ! -d 127.0.0.1 ! -s 127.0.0.1 -p tcp -m tcp --tcp-flags ACK,RST ACK,RST -j DROP

iptables -t nat -A POSTROUTING -o $_out_if_1 -j MASQUERADE
iptables -t nat -A POSTROUTING -o $_out_if_2 -j MASQUERADE
iptables -A FORWARD -i $_out_if_1 -o $_inc_if -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $_out_if_2 -o $_inc_if -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $_inc_if -o $_out_if_1 -j ACCEPT
iptables -A FORWARD -i $_inc_if -o $_out_if_2 -j ACCEPT

### set iptables *nat
#*nat PREROUTING (For middlebox)
iptables -t nat -A PREROUTING -d $_virt_addr -i $_inc_if -p tcp --syn -j REDIRECT --to-ports $TOR_PORT
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 22 -j REDIRECT --to-ports 22
iptables -t nat -A PREROUTING -i $_inc_if -p udp --dport 5300 -j REDIRECT --to-ports $DNS_PORT
iptables -t nat -A PREROUTING -i $_inc_if -p udp --dport 53 -j REDIRECT --to-ports $DNS_PORT
iptables -t nat -A PREROUTING -i $_inc_if -p udp   -j REDIRECT --to-ports $TOR_PORT
iptables -t nat -A PREROUTING -i $_inc_if -p icmp  -j REDIRECT --to-ports $TOR_PORT
iptables -t nat -A PREROUTING -i $_inc_if -p tcp --syn -j REDIRECT --to-ports $TOR_PORT
echo -e $RESETCOLOR
exit 0

	export BLUE='\033[1;94m'
	export GREEN='\033[1;92m'
	export RED='\033[1;91m'
	export RESETCOLOR='\033[1;00m'

sleep 3
	echo -e "	 anonym8 (v 2.0) Usage Ex:\n
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
	$RED anonym8 start_mac_wlan0$BLUE  =>$GREEN Start macchanger wlan0 services
	$RED anonym8 stop_mac_wlan0$BLUE   =>$GREEN Stop macchanger wlan0 services	
	$RED anonym8 start_mac$BLUE        =>$GREEN Start macchanger services
	$RED anonym8 stop_mac$BLUE         =>$GREEN Stop macchanger services
	$RED anonym8 status_mac$BLUE       =>$GREEN macchanger status\n
	$BLUE----[ arm related features ]----
	$RED anonym8 start_arm$BLUE        =>$GREEN Start Monitoring Anonymizing Relay (arm)\n
	$BLUE----[ wipe related features ]----
	$RED anonym8 wipe$BLUE             =>$GREEN cache, RAM & swap-space cleaner\n
	$BLUE----[ hostname related features ]----
	$RED anonym8 change_hostname$BLUE  =>$GREEN Randomly Spoofing Hostname
	$RED anonym8 custom_hostname$BLUE =>$GREEN Custom Spoofing Hostname	
	$RED anonym8 restore_hostname$BLUE =>$GREEN Restore Default Hostname
	$RED anonym8 status_hostname$BLUE  =>$GREEN Show Current Hostname\n"

	
echo -e $RESETCOLOR
exit 0

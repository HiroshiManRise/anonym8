echo -e "This script will desinstall anonym8 on your computer...\n"
sleep 1
rm -rf /opt/anonym8
rm -rf /usr/share/applications/anonym8.desktop
rm -rf /etc/init.d/anonym8.sh
rm -rf /usr/bin/anonym8
rm -rf /usr/bin/anON
rm -rf /usr/bin/anOFF
apt-get remove tor macchanger resolvconf dnsmasq polipo privoxy tor-arm libnotify-bin curl bleachbit
rm -rf /etc/polipo/config
rm -rf /etc/privoxy/config
rm -rf /etc/tor/torrc
echo -e "\nUninstalled anonym8 and all its dependencies"
#! /bin/bash 
#######################################################################################################
# Author: Justin McAfee 									      #
# Contact: me@justinmcafee.com									      #
# Purpose: To personalize a new instance of the Linux Desktop using a Debian based distro with APT.   #
# Date: 24JAN2021										      #
# Revision: 6											      #
#######################################################################################################

checkroot(){
if [ $(whoami) != root ]; then
	printf "Please re-run with sudo.\n"
	exit 
fi
}

errorcheck(){
if [ $? -ne 0 ];then
	printf " An error was encountered\n"
	exit
fi
return
}

aptupdate(){
apt autoremove -y && apt autoclean -y && apt update && apt upgrade -y 
errorcheck

}

installapps(){
apt install -y nload hping3 mtr nethogs speedtest-cli iperf3 screen mosh nmap netcat endlessh ufw git transmission vim openssh-server tldr  shellcheck 
errorcheck
}

#
# Note: resolvconf must be installed if not present. While a cleaner solution would be to check for it, attempting to install it has no negative effects.
# wireguard should have it as a dependency but doesn't, hence a manual install.




Finished(){

printf "\n Congratulations, You've successfully configured your new computer.\n Checkout the great features like nmap, guake, and shellcheck!\n"  
}

checkroot
aptupdate
installapps

Finished

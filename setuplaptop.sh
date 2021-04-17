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
apt install -y nload hping3 ostinato yersinia mtr nethogs speedtest-cli iperf3 wireguard resolvconf screen mosh spotify-client nmap netcat endlessh ufw guake git transmission thunderbird vim openssh-server tldr fprintd libpam-fprintd shellcheck 
errorcheck
}

#
# Note: resolvconf must be installed if not present. While a cleaner solution would be to check for it, attempting to install it has no negative effects.
# wireguard should have it as a dependency but doesn't, hence a manual install.

installSignal(){
which signal-desktop
if [ $(echo $?) -ne 1 ]; then
	printf "Signal-Desktop already installed. Skipping\n"
	return
fi 
printf "Installing Signal Desktop Keys\n"
wget -O- https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
errorcheck
printf "Adding Signal Repo\n"
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
errorcheck
printf "Installing Signal Desktop"
sudo apt update && sudo apt install -y signal-desktop
errorcheck
}

installHowdy(){
which howdy
if [ $(echo $?) -ne 1 ]; then
	printf "Howdy already installed. Skipping\n"
	return
fi
printf "Adding Repository" 
add-apt-repository ppa:boltgolt/howdy
errorcheck
aptupdate
errorcheck
apt install howdy
errorcheck
#read -r -p "Do you want to configure howdy now? [Y/n]: " answer
#if [ "$answer" = "Y" ]; then
#fi
}

installButtercup(){
true
}

Finished(){
printf "All apps installed successfully.\n"
read -r -p "Would you like to configure Fingerprint Auth for Sudo? Y/N: " answer
if [ "$answer" == "Y" ];then
	fprintd-enroll 
	read -p "Use the spacebar to activate the Fingerprint Authentication option. Press ENTER to continue."
	pam-auth-update
elif [ "$answer" == "y" ]; then
	fprintd-enroll
	read -p "Use the spacebar to activate the Fingerprint Authentication option. Press Enter to continue."
	pam-auth-update
fi
printf "\n Congratulations, You've successfully configured your new computer.\n Checkout the great features like nmap, guake, and shellcheck!\n"  
}

checkroot
aptupdate
installapps
installSignal
#installButtercup
Finished

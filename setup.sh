#!/bin/bash 

publickeyURL=https://gist.githubusercontent.com/justinamcafee/17a0d85e4833a9bfa11a2f82ba34b6fa/raw/a22b16bcea1691b7d64919590cdb38a0ce6c7f98/id_rsa.pub
buildscriptURL=https://raw.githubusercontent.com/justinamcafee/QuickSetup/main/setupheadless.sh
user=justin

checkexit() {
    if [ $? -ne 0 ]
    then printf "\n Somethings broken. Exiting. \n"
    exit
    fi
}

apt update 
checkexit
apt upgrade -y 
checkexit
adduser $user --gecos "$user,,,," --disabled-password
echo "$user:ChangeMe" | chpasswd
checkexit
mkdir /home/$user/.ssh
wget $publickeyURL
cat id_rsa.pub >> /home/$user/.ssh/authorized_keys
rm ./id_rsa.pub
wget $buildscriptURL -O ./setupheadless.sh 
chmod +x ./setupheadless.sh 
./setupheadless.sh 
usermod -a -G sudo $user 
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
service ssh restart

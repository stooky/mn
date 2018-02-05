#!/bin/bash

node="Deviant"
nodebinary="Deviantd"
default_port="7118"
setup_mode="F"

clear

echo "###########################################################"
echo "#"
echo "#"
echo "#   $node Quick Setup and Installation Script"
echo "#"
echo "#   Use this script to install nodes after your first"
echo "#"
echo "#   MAKE SURE THAT YOU HAVE PLACED YOUR $node binary "
echo "#    in the same directory that you are running this "
echo "#    script from.                                     "
echo "#"
echo "#"
echo "###########################################################"

echo "#"
echo "#"

read -e -p "Welcome to the $node setup. Press any key to continue" continue

echo "#"
echo "#"

user=NONE
read -e -p "Enter the username that will run the $node node: " user
    if [[ "$user" == "" ]]; then
	user=NONE
    fi

echo "#"
echo "#"

read -e -p "Enter the ip address of the server : " ip
    if [[ "$ip" == "" ]]; then
        key="[REPLACE WITH YOUR IP ADDRESS]"
    fi

echo "#"
echo "#"


	read -e -p "Enter the masternode private key : " key
    if [[ "$key" == "" ]]; then
        key="[REPLACE WITH YOUR masternode genkey]"
    fi

echo "#"
echo "#"

read -e -p "Add swap space? (Recommended) [Y/n] : " add_swap
if [[ ("$add_swap" == "y" || "$add_swap" == "Y" || "$add_swap" == "") ]]; then
echo "#"
echo "#"
    read -e -p "Swap Size [2G] : " swap_size
    if [[ "$swap_size" == "" ]]; then
        swap_size="2G"
    fi
fi

echo "#"
echo "#"

read -e -p "Install Fail2ban? (Recommended) [Y/n] : " install_fail2ban

echo "#"
echo "#"

read -e -p "Install UFW and configure ports? (Recommended) [Y/n] : " UFW
if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
    read -e -p "Enter port for your node [default: "$default_port"] : " port
    if [[ "$port" == "" ]]; then
        port="$default_port"
    fi
fi

echo "#"
echo "#"

# Add swap if needed
if [[ ("$add_swap" == "y" || "$add_swap" == "Y" || "$add_swap" == "") ]]; then
    if [ ! -f /swapfile ]; then
        echo && echo "Adding swap space..."
        sleep 3
        sudo fallocate -l $swap_size /swapfile
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
        sudo swapon /swapfile
        echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
        sudo sysctl vm.swappiness=10
        sudo sysctl vm.vfs_cache_pressure=50
        echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
        echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
    else
        echo && echo "WARNING: Swap file detected, skipping add swap!"
        sleep 3
    fi
fi


# Install firewall if needed
if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
    echo && echo "Installing UFW..."
    sleep 3
    sudo apt-get -y install ufw
    echo && echo "Configuring UFW..."
    sleep 3
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw allow $port/tcp
    echo "y" | sudo ufw enable
    echo && echo "Firewall installed and enabled!"
fi

# variables for reuse
REQUIRED_DISTR="Ubuntu 16.04"
TMP_DIR=/tmp

clear
echo "****************************************************************"
echo "  This script will prepare Linux for a masternode"
echo "****************************************************************"
echo
echo



echo
echo "Installing bitcoin PPA..."
echo

sudo apt-get -y update
# install ppa
sudo apt-get -y install software-properties-common
# Add Berkely PPA
sudo apt-add-repository -y ppa:bitcoin/bitcoin
# update repository to include Berkely
sudo apt-get -y update

# Install required packages
echo
echo "Installing base packages and dependencies..."
echo

sudo apt-get -y install \
    autoconf \
    automake \
    autotools-dev \
    bsdmainutils \
    build-essential \
    git \
    htop \
    libboost-dev \
    libboost-all-dev \
    libboost-chrono-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-test-dev \
    libboost-thread-dev \
    libdb4.8-dev \
    libdb4.8++-dev \
    libevent-dev \
    libminiupnpc-dev \
    libssl-dev \
    libtool \
    libzmq3-dev \
    nano \
    pkg-config \
    python-pip \
    software-properties-common \
    tmux \
    unzip \
    virtualenv \
    wget \
    zip \
    libgmp3-dev \




# Create the configuration file

echo && echo "Creating $node Configuration File"
echo
sleep 3
rpcuser=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
rpcpassword=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
touch ./$node.conf
echo 'rpcuser='$rpcuser'
rpcpassword='$rpcpassword'
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=256
rpcallowip=127.0.0.1
port='$port'
masternode=1
masternodeaddr='$ip':'$port'
masternodeprivkey='$key'
' | tee ./$node.conf


# Copying the $node binary
	mv ./$nodebinary /usr/local/bin

	echo "."
	echo "."
	echo "."
	echo "."
	echo "Creating $node masternode directory /home/$user/.$node."
	mkdir /home/$user/.$node
	echo "."
	echo "."
	echo "Giving $user permissions to $node directory."
	chown $user.$user /home/$user/.$node  
	echo "."
	echo "."
	echo "Moving the $node.conf file to the $node directory."
	mv ./$node.conf /home/$user/.$node
	echo "."
	echo "."
	echo "Giving $user permissions to the $node.conf file."
	chown $user.$user /home/$user/.$node/$node.conf

	echo "."
	echo "."
	echo "."
	echo "."
	echo "#####################################################"
	echo "# Thank you for setting up a $node masternode. You  #"
	echo "#   will find your binary files in /usr/local/bin.  #"
	echo "#  Now you can login as the $user user that you     #"
	echo "#  created.                                         #"
	echo "#####################################################"


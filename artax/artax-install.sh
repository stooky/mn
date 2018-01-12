#!/bin/bash


# variables for reuse
REQUIRED_DISTR="Ubuntu 16.04"
DISTR_CODENAME="xenial"
ARTAX_VERSION=1.2.0
# CRON_SENTINEL='* * * * * cd ~/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1'
TMP_DIR=/tmp

clear
echo "********************************************************************************************************"
echo "  This script will prepare Linux for a masternodeg"
echo
echo "********************************************************************************************************"
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
    unzip \
    virtualenv \
    wget \
    zip \





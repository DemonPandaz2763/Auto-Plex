#!/bin/bash

##################################################

# Script based on howtohifi's rpi headless setup #
# Not tested, made from howtohifi's website.     #

##################################################

red='\e[0;31m'
green='\e[0;32m'
yellow='\e[0;33m'
reset='\e[0m'

USERNAME=$(whoami)

################################
# --> Check for root <--
################################
if [[ $EUID -ne 0 ]]; then
    echo -e "${red}[!]${reset} This script must be run as root" 
    exit 1
fi

################################
# --> Check OS <--
################################
echo -en "${yellow}[?]${reset} Are you running Raspbian OS Lite? [y/n]: "
read -r answer

if [[ $answer != "y" ]]; then
    echo -e "${red}[!]${reset} This script is only tested on Raspbian OS Lite"
    exit 1
fi

################################
# --> Check IP <--
################################
echo -en "${yellow}[?]${reset} Enter your IP address: "
read -r HOSTNAME
echo "############################################################"

ip_regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

if [[ ! $HOSTNAME =~ $ip_regex ]]; then
    echo -e "${red}[!]${reset} Invalid IP address"
    exit 1
fi

################################
# --> Setup system <--
################################
echo -e "${green}[+]${reset} Updating system"
sudo apt update > /dev/null 2>&1
sudo apt upgrade -y > /dev/null 2>&1

sudo apt install apt-transport-http -y

#################################
# --> Install Plex <--
#################################
echo -e "${green}[+]${reset} Installing Plex"
curl https://downloads.plex.tv/plex-keys/PlexSign.key | gpg --dearmor | sudo tee /usr/share/keyrings/plex-archive-keyring.gpg >/dev/null

echo deb [signed-by=/usr/share/keyrings/plex-archive-keyring.gpg] https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
sudo apt update > /dev/null 2>&1

sudo apt install plexmediaserver -y

#################################
# --> Modify boot <--
#################################
echo -e "${green}[+]${reset} Modifying boot"
echo -e "  ${yellow}[!]${reset} Adding 'ip=${HOSTNAME}' to boot"

echo "ip=${HOSTNAME}" | sudo tee -a /boot/firmware/config.txt > /dev/null 2>&1

#################################
# --> Make library directories <--
#################################
echo -e "${green}[+]${reset} Creating library directories"
echo -e "  ${yellow}[!]${reset} Creating /var/lib/plexmediaserver/Movies"
echo -e "  ${yellow}[!]${reset} Creating /var/lib/plexmediaserver/Shows"
echo -e "  ${yellow}[!]${reset} Folders owned by ${USERNAME} for scp convenience"

sudo mkdir -p /var/lib/plexmediaserver/Movies
sudo mkdir -p /var/lib/plexmediaserver/Shows

sudo chown $USERNAME:$USERNAME /var/lib/plexmediaserver/Movies
sudo chown $USERNAME:$USERNAME /var/lib/plexmediaserver/Shows

#################################
# --> Info <--
#################################
echo -e "${green}[+]${reset} Plex server available at http://${HOSTNAME}:32400/web/"
echo -e "  ${green}[+]${reset} Transfer movies with: scp /path/to/movie ${USERNAME}@${HOSTNAME}:/var/lib/plexmediaserver/Movies"
echo -e "  ${green}[+]${reset} Transfer shows with: scp /path/to/show ${USERNAME}@${HOSTNAME}:/var/lib/plexmediaserver/Shows"
echo -e "${yellow}[!]${reset} Note: Additional setup needed on the website. Add libraries to plex from there."
echo -e "${Yellow}[!]${reset} Note: Not recommended for public use. If you want to make it public, set it up manually\n"
echo -e "${green}[+]${reset} Reboot required after installation"
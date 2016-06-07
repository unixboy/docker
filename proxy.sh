#!/bin/bash
#this simply adds some entries
#	echo "Simply execute the script either by"
#	echo "1 . bash script.sh"
#	echo "2 . chmod +x ./script.sh"
#	echo "    ./script.sh"
#	echo "Leave username empty if you dont have to set usernames and passwords"
#profile file is bash_profile
profile=$HOME/.bash_profile
if [[ $EUID -ne 0 ]]
	then
	echo "This script must be run as root" 1>&2
	exit 1
fi
#proxy address is 172.16.16.2. Change if necessary
proxy_address=172.16.16.2:3128
#check which is our target
if [[ -e /etc/debian-version ]];
	then
	echo "Setting up for a Ubuntu/Debian system"
	file=/etc/apt/apt.conf
	
	echo "Enter your username, [ eg: 9909004378]."
	read uname
	if [[ -z "${uname}" ]];
	then
		#if no username, then no password either
		echo Acquire::http::Proxy \"http://"${proxy_address}"\" >> $file
		echo Acquire::https::Proxy \"http://"${proxy_address}"\" >> $file
		echo Acquire::ftp::Proxy \"http://"${proxy_address}"\" >> $file
		echo export http_proxy=http://"${proxy_address}"/ >> $profile
		exit 0
	else
		echo "Enter your password "
		read pass	
		echo Acquire::http::Proxy \"http://"${uname}":"${pass}"@"${proxy_address}"\" >> $file
		echo Acquire::https::Proxy \"https://"${uname}":"${pass}"@"${proxy_address}"\" >> $file
		echo Acquire::ftp::Proxy \"ftp://"${uname}":"${pass}"@"${proxy_address}"\" >> $file
		echo export http_proxy=http://"${uname}":"${pass}"@"${proxy_address}"/ >> $profile
		exit 0	
	fi

elif [[ -e /etc/fedora-release ]]
	then
	echo "Setting up for a fedora system"
	file=/etc/yum.conf

	echo "Enter your username, [ eg: 9909004378]."
	read uname
	if [[ -z "${uname}" ]]
		then
		echo proxy=http://"${proxy_address}" >> $file
		echo proxy=https://"${proxy_address}" >> $file
		echo export http_proxy=http://"${proxy_address}"/ >> $profile
		echo proxy=ftp://"${proxy_address}" >> $file
	else
		echo "Enter your password "
		read pass	
		echo proxy=http://"${uname}":"${pass}"@"${proxy_address}" >> $file
		echo proxy=https://"${uname}":"${pass}"@"${proxy_address}" >> $file
		echo export http_proxy=http://"${uname}":"${pass}"@"${proxy_address}"/ >> $profile
		echo proxy=ftp://"${uname}":"${pass}"@"${proxy_address}" >> $file
		exit 0	
	fi

else
	echo "This distro is not supported yet - please contact the maintainers to include this distro"
	echo "Setting only the environmental variables ..."
    echo "Enter your username, [ eg: 9909004378]."
	read uname
	if [[ -z "${uname}" ]]
		then
		echo export http_proxy=http://"${proxy_address}"/ >> $profile
	else
		echo "Enter your password "
		read pass	
		echo export http_proxy=http://"${uname}":"${pass}"@"${proxy_address}"/ >> $profile
		exit 0	
fi


#!/bin/bash

# The original script is provided by:duy13
# https://github.com/duy13/vDDoS-Protection/
# This script is modified by HostingFuze Network for vddos-hfn sensor

PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/bin
source ~/.bashrc  >/dev/null 2>&1
source ~/.bash_profile  >/dev/null 2>&1

if [ "$1" = "install" ]; then
	yourchoice=1
else
if [ "$1" = "remove" ]; then
	yourchoice=2
fi
fi
if [ "$yourchoice" = "1" ]; then
	echo ''
	echo '==>	MASTER SERVER INSTALL for vDDoS-HFN Sensor...'
# Install vDDoS Proxy Protection:
latest_version=`/usr/bin/curl -L https://raw.githubusercontent.com/duy13/vDDoS-Protection/master/CHANGELOG.txt|grep '*vDDoS-' |awk 'NR==1' |tr -d '*vDDoS-'|tr -d ':'`
/usr/bin/curl -L https://github.com/duy13/vDDoS-Protection/raw/master/vddos-$latest_version.tar.gz -o /root/vddos-$latest_version.tar.gz
vddos_version=$latest_version

tar -xvf /root/vddos-$latest_version.tar.gz >/dev/null 2>&1
cd vddos-$latest_version
chmod 755 -R *.sh  >/dev/null 2>&1
chmod 755 -R */*.sh  >/dev/null 2>&1

	if [ ! -f vddos-$vddos_version.sh  ]; then
		echo 'ERROR! vddos-'$vddos_version'.sh not found!'
		exit 0
	fi
	if [ ! -d vddos  ]; then
		echo 'ERROR! "vddos" not found!'
		exit 0
	fi
	if [ ! -d master  ]; then
		echo 'ERROR! "master" not found!'
		exit 0
	fi
	if [ ! -d auto-add  ]; then
		echo 'ERROR! "auto-add" not found!'
		exit 0
	fi
	if [ ! -d auto-switch  ]; then
		echo 'ERROR! "auto-switch" not found!'
		exit 0
	fi
	# Install for vDDoS Service
	chmod 700 vddos-$vddos_version.sh
	./vddos-$vddos_version.sh setup
	./vddos-$vddos_version.sh autostart
	if [ ! -f /vddos/vddos  ]; then
		echo 'ERROR! vDDoS installation failed!'
exit 0
	fi
	cp vddos-$vddos_version.sh /usr/bin/vddos
	chmod 700 /usr/bin/vddos
	echo '@monthly root /usr/bin/vddos-master synall && sleep 5 && /usr/bin/vddos-master reloadall' >> /etc/crontab
	echo '2 2 * * * root acme.sh --upgrade ; /usr/bin/vddos-autoadd ssl-again' >> /etc/crontab
	#### Install for MASTER Server
	cp -a master /vddos
	chmod 700 /vddos/master/master.sh
	ln -s /vddos/master/master.sh /usr/bin/vddos-master
	cp -a auto-add /vddos
	chmod 700 /vddos/auto-add/*.sh
	ln -s /vddos/auto-add/vddos-add.sh /usr/bin/vddos-add
	ln -s /vddos/auto-add/vddos-autoadd.sh /usr/bin/vddos-autoadd
	cp -a auto-switch /vddos
	chmod 700 /vddos/auto-switch/*.sh
	ln -s /vddos/auto-switch/vddos-autoswitch.sh /usr/bin/vddos-autoswitch
	ln -s /vddos/auto-switch/vddos-switch.sh /usr/bin/vddos-switch
	ln -s /vddos/auto-switch/vddos-sensor.sh /usr/bin/vddos-sensor
if [ -f /vddos/vddos ]; then
	curl -L https://github.com/duy13/vDDoS-Layer4-Mapping/raw/master/vddos-layer4-mapping -o /usr/bin/vddos-layer4
	chmod 700 /usr/bin/vddos-layer4
	/root/.acme.sh/acme.sh --set-default-ca  --server  letsencrypt >/dev/null 2>&1
rm -rf /root/vddos-$latest_version/
rm -f /root/vddos-$latest_version.tar.gz
echo 'Congratulations! Master vDDoS Server installed successfully!'
else
	echo 'Install vDDoS Proxy Protection Failed!'
	exit 1
fi
fi
if [ "$yourchoice" = "2" ]; then
	echo ''
	echo ' REMOVE ALL!!! 
	In 10 seconds countdown ALL vDDoS Service will be removed... 
	Attention, it can stop the services for a short period of time.
    A backup will be created with the / vddos folder. This update is at your own risk. If you want an update with minimal losses, choose a tariff plan. See https://www.hfn.ee
	Press Ctrl+C to stop this:'
	echo '	Wait 10s...'
	sleep 15
	echo '...'
	sleep 2
	echo '...'
	date=`date +"[DATE=%d-%m-%Y_TIME=%Hh%M]"`
	echo ' START BACKUP ALL to vDDoS-BAK-'$date''
	mkdir -p /root/vDDoS-BAK-$date
	mv /vddos/ /root/vDDoS-BAK-$date  >/dev/null 2>&1
	cp -a /letsencrypt /root/vDDoS-BAK-$date  >/dev/null 2>&1
	echo 'START REMOVE ALL...'
	/usr/bin/vddos stop  >/dev/null 2>&1
	rm -rf /vddos
	rm -rf /usr/lib64/vddos/modules
	rm -rf /var/log/vddos
	rm -rf /var/cache/vddos
	rm -rf /usr/bin/vddos*
	echo 'REMOVE ALL WAS SUCCESSFUL!!!'
echo
read -r -p "Reinstall laste version vDDos ? [Y/n] " input
case $input in
      [yY][eE][sS]|[yY])
            yourchoice=1
            ;;
      [nN][oO]|[nN])
            echo "Try again using this: bash vddos-hfn-install.sh"
            exit 0
            ;;
      *)
            echo "Invalid input...try again"
            exit 1
            ;;
esac
fi
    echo
    echo ++++++++++++++++++++++++++++++++++++++
    echo + DDoS Filter by HostingFuze Network +
    echo +....Copyright @ 2022 ... tactu .... +
    echo ++++++++++++++++++++++++++++++++++++++
    echo
echo error please run :
echo - for install: bash install_vddos.sh install
echo - for remove: bash install_vddos.sh remove

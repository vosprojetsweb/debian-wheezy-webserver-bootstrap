#!/bin/bash

#
#	christophe.borsenberger@vosprojetsweb.pro
#
#	syntax : wget -q -O - https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/post-install/setup.sh | sudo /bin/bash
#

set -e

# Test que le script est lance en root
if [ $EUID -ne 0 ]; then
  echo "Le script doit etre lance en root !" 1>&2
  exit 1
fi



displaytitle() {
	echo -e "\n\n${PURPLE}------------------------------------------------------------------------------"
	echo  "$*"
	echo -e "------------------------------------------------------------------------------${NC}"
}

# Configuration
APT_GET="apt-get --yes"
WGET="wget -m --no-check-certificate"
PURPLE='\e[1;35m'
NC='\e[0m'
SOURCES_LIST="https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/post-install/conf/sources.list"


### 1. On installe le nouveau fichier source.list de apt
displaytitle "-- Telechargement du fichier sources.list
-- $SOURCES_LIST"

cp --no-clobber /etc/apt/sources.list /etc/apt/sources.list-BACKUP
$WGET -O /etc/apt/sources.list $SOURCES_LIST


### 2. On installe les differentes cles des nouveaux depots
displaytitle "-- Installation des cles des nouveaux depots"

# http://www.dotdeb.org/instructions/
$WGET -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add -

# http://www.percona.com/doc/percona-server/5.5/installation/apt_repo.html
gpg --keyserver  hkp://pgp.mit.edu --recv-keys 1C4CBDCDCD2EFD2A
gpg -a --export CD2EFD2A | apt-key add -


### 3. On met a jour le systeme
displaytitle "-- Mise a jour du systeme"
$APT_GET update
$APT_GET upgrade

### 4. On installe les paquets necessaires
LIST="sudo debian-goodies vim logrotate"
displaytitle "-- Installation des paquets ${LISTE}"
$APT_GET install $LIST

### 5. On defini l'environement de la machine : development | production
echo production > /usr/local/etc/environment

### 6. On interdit l'utilisation d'ipv6
displaytitle "-- Telechargement sysctl.conf"
$WGET -O "/etc/sysctl.d/local.disable.ipv6.conf" "https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/post-install/conf/disable.ipv6.conf"
sysctl -p

### 6. On verifie si des demons doivent etre relances
displaytitle "-- Verification des demons"
checkrestart

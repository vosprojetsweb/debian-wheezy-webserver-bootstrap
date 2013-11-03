#!/bin/bash

#
#	christophe.borsenberger@vosprojetsweb.pro
#
#	syntax : wget -q -O - https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/tools/setup.sh | sudo /bin/bash
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

# Configuration des outils
APT_GET="apt-get --yes"
WGET="wget -m --no-check-certificate"
PURPLE='\e[1;35m'
NC='\e[0m'
GIT="https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master"

### 1. Installation
# Collectd : Monitoring
# Log Watch : Analyse de log
LISTE="collectd logwatch"

displaytitle "Installation des paquets : ${LISTE}"
$APT_GET install $LISTE

	
	
### 2. Configuration

## Collectd
displaytitle "Preparation monitoring nginx /  php-fpm"
# On prepare un server nginx pour le monitoring de nginx et de php-fpm
$WGET -O /etc/nginx/sites-available/monitoring "${GIT}/monitoring/conf/collectd/nginx-server-monitoring"
ln -s /etc/nginx/sites-available/monitoring /etc/nginx/sites-enabled/monitoring
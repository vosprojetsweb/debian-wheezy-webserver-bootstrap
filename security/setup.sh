#!/bin/bash

#
#	christophe.borsenberger@vosprojetsweb.pro
#
#	syntax : wget -q -O - https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/security/setup.sh | sudo /bin/bash
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
RED='\e[1;31m'
NC='\e[0m'

# Firewall
displaytitle "-- Telechargement firewall"
$WGET -O "/etc/network/if-up.d/firewall" "https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/security/conf/firewall"

# Sysctl
displaytitle "-- Telechargement sysctl.conf"
$WGET -O "/etc/sysctl.d/local.security_hardening.conf" "https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/security/conf/sysctl.conf"
sysctl -p

# fail2ban
displaytitle "-- installation fail2ban"
$APT_GET install fail2ban

echo -e "\n${RED}!!! Verifier que le port SSH est le bon avant d'installer le firewall !!!${NC}\n"
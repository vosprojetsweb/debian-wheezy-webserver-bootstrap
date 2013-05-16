#!/bin/bash
set -e

#
#	christophe.borsenberger@vosprojetsweb.pro
#
#	syntax : wget -q -O - https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/lemp/setup.sh | sudo /bin/sh
#


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
GIT="https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master"

### 1. Installation

#nginx
LISTE="nginx"

#php-fpm
LISTE=$LISTE" php5 php5-fpm php5-apc php5-cli php5-xhprof php5-intl"

#percona server
LISTE=$LISTE" mysql-server-5.5 mysql-client-5.5 php5-mysqlnd percona-toolkit"

displaytitle "-- Installation des paquets ${LISTE}"
$APT_GET install $LISTE


### 2. Configuration

# nginx
displaytitle "-- Configuration Nginx"
$WGET -O "/etc/nginx/nginx.conf" "${GIT}/lemp/conf/nginx/nginx.conf"
$WGET -O "/etc/nginx/conf.d/http_security.conf" "${GIT}/lemp/conf/nginx/http_security.conf"


# php-fpm
displaytitle "-- Configuration php-fpm"
cp --no-clobber "/etc/php5/fpm/pool.d/www.conf" "/etc/php5/fpm/pool.d/www.example"
$WGET -O "/etc/php5/fpm/conf.d/local.ini" "${GIT}/lemp/conf/php-fpm/local.ini"
$WGET -O "/etc/php5/fpm/conf.d/local.conf" "${GIT}/lemp/conf/php-fpm/local.conf"
$WGET -O "/etc/php5/fpm/pool.d/www.conf" "${GIT}/lemp/conf/php-fpm/pool-www.conf"
$WGET -O "/etc/nginx/conf.d/php-fpm.conf" "${GIT}/lemp/conf/php-fpm/nginx-php-fpm.conf"

mkdir -p /var/log/php5/

# mysql
displaytitle "-- Configuration MySQL"
$WGET -O "/etc/mysql/my.cnf" "${GIT}/lemp/conf/mysql/my.cnf"

displaytitle "-- Redemarrage des demons"
/etc/init.d/nginx restart
/etc/init.d/php5-fpm restart 
/etc/init.d/mysql restart


echo -e "${RED}!! Lancer la commande mysql_secure_installation !!${NC}"
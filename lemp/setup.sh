#!/bin/bash
set -e

#
#	christophe.borsenberger@vosprojetsweb.pro
#
#	syntax : wget -q -O - https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/lemp/setup.sh | sudo /bin/bash
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


downloadAndBackup()
{
	displaytitle "Telechargement du fichier $1"
	$WGET -O $2 $1
}

# Configuration
APT_GET="apt-get --yes"
WGET="wget --no-check-certificate --backup-converted"
PURPLE='\e[1;35m'
RED='\e[1;31m'
NC='\e[0m'
GIT="https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master"

### 1. Installation

#nginx
LISTE="nginx"

#php-fpm
LISTE=$LISTE" php5 php5-fpm php5-cli php5-xhprof php5-intl php5-curl"

#mysql server
LISTE=$LISTE" percona-server-server-5.6 percona-server-client-5.6 php5-mysqlnd percona-toolkit percona-xtrabackup percona-server-common-5.6 mysql-common"

displaytitle "-- Installation des paquets ${LISTE}"
$APT_GET install $LISTE


### 2. Configuration

# nginx
displaytitle "-- Configuration Nginx"
downloadAndBackup "${GIT}/lemp/conf/nginx/nginx.conf" "/etc/nginx/nginx.conf"
downloadAndBackup "${GIT}/lemp/conf/nginx/http_security.conf" "/etc/nginx/conf.d/http_security.conf"
downloadAndBackup "${GIT}/lemp/conf/nginx/http_auth.conf" "/etc/nginx/conf.d/http_auth.conf"

# Création du fichier contenant les mots de passe liés à l'authentification http
touch /etc/nginx/.htpasswd
chown root:www-data /etc/nginx/.htpasswd
chmod 640 /etc/nginx/.htpasswd


# php-fpm
displaytitle "-- Configuration php-fpm"
downloadAndBackup "${GIT}/lemp/conf/php-fpm/pool-www.conf" "/etc/php5/fpm/pool.d/www.conf" 
downloadAndBackup "${GIT}/lemp/conf/php-fpm/www.example.com.ini" "/etc/php5/conf.d/www.example.com.ini" 
downloadAndBackup "${GIT}/lemp/conf/php-fpm/php-fpm.conf" "/etc/php5/fpm/php-fpm.conf" 
downloadAndBackup "${GIT}/lemp/conf/php-fpm/nginx-php-fpm.conf" "/etc/nginx/conf.d/php-fpm.conf"


# Configuration logs php
mkdir -p /var/log/php5/
downloadAndBackup "${GIT}/lemp/conf/php-fpm/logrotate.conf" "/etc/logrotate.d/php5-fpm"

touch /var/log/php5/php_errors.log
chown www-data:adm /var/log/php5/php_errors.log
chmod 600 /var/log/php5/php_errors.log


# mysql
displaytitle "-- Configuration MySQL"
mkdir -p /var/log/mysql/
mkdir /etc/mysql/conf.d/
touch /etc/mysql/conf.d/.keepme
downloadAndBackup "${GIT}/lemp/conf/mysql/my.cnf" "/etc/mysql/my.cnf"




displaytitle "-- Redemarrage des demons"
/etc/init.d/nginx restart
/etc/init.d/php5-fpm restart 
/etc/init.d/mysql restart


echo -e "${RED}!! Lancer la commande mysql_secure_installation !!${NC}"

#!/bin/bash

#
#	christophe.borsenberger@vosprojetsweb.pro
#	
#	Install : liquibase
#
#	syntax : wget -q -O - https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/devel-tools/database/setup.sh | sudo /bin/bash
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
WGET="wget --no-check-certificate"
PURPLE='\e[1;35m'
NC='\e[0m'

1. Liquibase
wget -O /usr/local/lib/liquibase.zip http://sourceforge.net/projects/liquibase/files/latest/download
unzip /usr/local/lib/liquibase.zip -d /usr/local/lib/liquibase
ln -s /usr/local/lib/liquibase/liquibase /usr/local/bin/liquibase

2. MySQL connector J
cd /usr/local/lib/
wget -O mysql-connector-java-5.1.32.tar.gz http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.32.tar.gz
tar -xzvf mysql-connector-java-5.1.32.tar.gz

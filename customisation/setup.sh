#!/bin/bash

#
#	christophe.borsenberger@vosprojetsweb.pro
#
#	Copie des fichiers de configuration pout bash et vim
#
#	syntax : 
#		Pour les utlisateurs non root
#		wget -q -O - https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/customisation/setup.sh | /bin/sh
#
#		Pour root
#		wget -q -O - https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/customisation/setup.sh | sudo /bin/sh

set -e

displaytitle() {
	echo -e "\n\n${PURPLE}------------------------------------------------------------------------------"
	echo  "$*"
	echo -e "------------------------------------------------------------------------------${NC}"
}


# Configuration
WGET="wget -m --no-check-certificate"
PURPLE='\e[1;35m'
NC='\e[0m'

HOME_PATH=`grep $USER /etc/passwd | cut -d: -f6`

#personnalisation bash
for filename in ".bashrc" ".bash_aliases"
do
	DIST_FILE="https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/customisation/conf/bash/${filename}"
	LOCAL_FILE="${HOME_PATH}/${filename}"
	
	displaytitle "-- Telechargement du fichier ${filename}
	$DIST_FILE"
	
	cp --no-clobber $LOCAL_FILE "${LOCAL_FILE}-BACKUP"
	$WGET -O $LOCAL_FILE $DIST_FILE
done


source $LOCAL_FILE
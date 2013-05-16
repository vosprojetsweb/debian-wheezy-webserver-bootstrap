#!/bin/bash

#
#	christophe.borsenberger@vosprojetsweb.pro
#
#	Copie des fichiers de configuration pout bash et vim
#
#	syntax : wget -q -O - https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/post-install/setup.sh | sudo /bin/sh
#

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

HOME_PATH=`grep $USERNAME /etc/passwd | cut -d: -f6`

#.bashrc
displaytitle ".bashrc"
cp --no-clobber "${HOME_PATH}/.bashrc" "${HOME_PATH}/.bashrc-BACKUP"
$WGET -O "${HOME_PATH}/.bashrc" https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/customisation/conf/bash/.bashrc
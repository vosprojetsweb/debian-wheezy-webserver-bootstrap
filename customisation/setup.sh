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

# Personnalisation bash
displaytitle "-- Personnalisation bash"

for filename in ".bashrc" ".bash_aliases"
do
	DIST_FILE="https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/customisation/conf/bash/${filename}"
	LOCAL_FILE="${HOME_PATH}/${filename}"
	
	if [ -f $LOCAL_FILE ]
	then 
		cp --no-clobber $LOCAL_FILE "${LOCAL_FILE}-BACKUP"
	fi
	
	$WGET -O $LOCAL_FILE $DIST_FILE
done

source $LOCAL_FILE




# Personnalisation vim
displaytitle "-- Personnalisation VIM"

mkdir -p "${HOME_PATH}/.vim/syntax"

VIMRC="${HOME_PATH}/.vimrc"
VIM_FILETYPE="${HOME_PATH}/.vim/filetype.vim"

if [ -f $VIMRC ]
then 
	cp --no-clobber $VIMRC "${VIMRC}-BACKUP"
fi

if [ -f $VIM_FILETYPE ]
then 
	cp --no-clobber $VIM_FILETYPE "${VIM_FILETYPE}-BACKUP"
fi

$WGET -O $VIMRC "https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/customisation/conf/vim/.vimrc"
$WGET -O $VIM_FILETYPE "https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/customisation/conf/vim/filetype.vim"
$WGET -O "${HOME_PATH}/.vim/syntax/nginx.vim" "https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/customisation/conf/vim/syntax/nginx.vim"

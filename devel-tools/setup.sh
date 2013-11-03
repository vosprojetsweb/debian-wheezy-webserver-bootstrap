#!/bin/bash

#
#	christophe.borsenberger@vosprojetsweb.pro
#	
#	Install : git, nodeJs, Composer, grunt, bower
#
#	syntax : wget -q -O - https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/devel-tools/setup.sh | sudo /bin/sh
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
WGET="wget --no-check-certificate"
PURPLE='\e[1;35m'
NC='\e[0m'
GIT="https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master"
GIT_CONFIG_DIR="/etc/git"


### 1. On installe les paquets necessaires
LIST="git python g++ make"
displaytitle "-- Installation des paquets ${LISTE}"
$APT_GET install $LIST


### 2. Configuration git
displaytitle "-- Configuration Git"
# Pour avoir de la couleur qd on utilise git en ligne de commande
git config --system color.ui true
# Utilise VIM comme éditeur par défaut
git config --system core.editor vim
#Supprime les espaces en fin de fichier
git config --system core.whitespace trailing-space
#Définir les fichiers à ignorer qui sont récurrents
git config --system core.excludesfile /etc/git/.gitignore

if [ ! -d "{GIT_CONFIG_DIR}" ]; then
	mkdir "${GIT_CONFIG_DIR}"
fi

$WGET -O /etc/git/.gitignore "${GIT}/devel-tools/conf/.gitignore"


### 3. Install Composer
displaytitle "-- Install Composer"
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer


### 4. Install NodeJS
displaytitle "-- Install nodejs"
mkdir ~/nodejs && cd $_
wget -N http://nodejs.org/dist/node-latest.tar.gz
tar xzvf node-latest.tar.gz && cd `ls -rd node-v*`
./configure
make install


### 5. Install Bower
displaytitle "-- install bower"
npm install -g bower
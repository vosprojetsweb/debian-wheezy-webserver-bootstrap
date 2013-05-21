#!/bin/bash

#
#	christophe.borsenberger@vosprojetsweb.pro
#
#	syntax : wget -q -O - https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/tools/setup.sh | sudo /bin/sh
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

# Git : gestionnaire des sources
LISTE=" git"

displaytitle "Installation des paquets : ${LISTE}"
$APT_GET install $LISTE

	
	
### 2. Configuration

# Git 
# 	Plus d'infos : http://git-scm.com/book/en/Git-on-the-Server-Setting-Up-the-Server

displaytitle "Configuration de Git"

# Création d'un user git 
adduser \
	--system \
	--shell /bin/bash \
	--gecos 'git version control' \
	--group \
	--disabled-password \
	--home /var/git \
	git

# On autorise git a se connecter en ssh
usermod -a -G sshusers,www-data git

# Creation du repertoire .ssh
mkdir /var/git/.ssh
chmod 700 /var/git/.ssh

# et du fichier authorized_keys
touch /var/git/.ssh/authorized_keys
chmod 600 /var/git/.ssh/authorized_keys

# Pour avoir de la couleur qd on utilise git en ligne de commande
git config --system color.ui true
# Utilise VIM comme éditeur par défaut
git config --system core.editor vim
#Supprime les espaces en fin de fichier
git config --system core.whitespace trailing-space

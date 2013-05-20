#!/bin/sh

#
# Le but du script est de preparer l'environnement de production pour acceuillir un nouveau site. 
# Les differentes etapes sont : 
#	- Creer le dossier ou se trouvera le site
#	- Creer le depot git, qui servira au deploiement du site
#	- Preparer une configuration nginx sommaire pour faire tourner le site
#
# syntax
#	wget -q -O - https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/tools/production/bootstrap-website.sh | sudo /bin/bash -s "server_name"
#	
#
#
# christophe.borsenberger@vosprojetsweb.pro
#

set -e

if [[ $EUID -ne 0 ]]; 
then
   echo "Ce script doit etre lancer en tant que root" >&2
   exit 1
fi

displaytitle() {
	echo -e "\n\n${PURPLE}------------------------------------------------------------------------------"
	echo  "$*"
	echo -e "------------------------------------------------------------------------------${NC}"
}

### Configuration
WGET="wget -m --no-check-certificate"
PURPLE='\e[1;35m'
NC='\e[0m'
GIT="https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master"

SERVER_NAME=${1:?"Erreur. Vous devez fournir le nom du serveur. Ex : www.example.com."}

### TODO : gerer les options pour modifier ces variables
PREFIX_WEBSITE_DIR="/var/www"
PREFIX_GIT_REPO="/var/git"
PREFIX_NGINX_CONFIG="/etc/nginx"
USERNAME="www-data"

WEBSITE_DIR="${PREFIX_WEBSITE_DIR}/${SERVER_NAME}"
GIT_REPO="${PREFIX_GIT_REPO}/${SERVER_NAME}.git"
GIT_HOOK_FILE="${GIT_REPO}/hooks/post-update"
NGINX_CONFIG_FILE="${PREFIX_NGINX_CONFIG}/sites-available/${SERVER_NAME}"
NGINX_CONFIG_LINK="${PREFIX_NGINX_CONFIG}/sites-enabled/${SERVER_NAME}"

### Creer le dossier ou se trouvera le site
displaytitle "Creation du repertoire ${WEBSITE_DIR}"
if [[ ! -d $WEBSITE_DIR ]]
then
	mkdir -p $WEBSITE_DIR
fi

chown -R $USERNAME:$USERNAME $WEBSITE_DIR
chmod -R 700 $WEBSITE_DIR


### Creer le depot git, qui servira au deploiement du site
if [[ ! -d $WEBSITE_DIR ]]
then
	displaytitle "Creation du depot git ${GIT_REPO}"
	mkdir -p $GIT_REPO
	git --bare init $GIT_REPO
fi

### Copie du hook qui deploiera le site web
if [[ ! -f $GIT_HOOK_FILE ]]
then
	$WGET -O $GIT_HOOK_FILE "${GIT}/tools/conf/git/deploy.sh"
	sed -i "s|__SERVER_NAME__|${SERVER_NAME}|g" "$GIT_HOOK_FILE"
fi

### Preparer la configuration nginx
if [[ ! -f $NGINX_CONFIG_FILE ]]
then
	displaytitle "Configuration server nginw ${NGINX_CONFIG_FILE}"
	$WGET -O $NGINX_CONFIG_FILE "${GIT}/tools/conf/nginx/php-mvc-website-template.conf"
	sed -i "s|__SERVER_NAME__|${SERVER_NAME}|g" "$NGINX_CONFIG_FILE"
	ln -s $NGINX_CONFIG_FILE $NGINX_CONFIG_LINK
	
	# Si tout est ok avec nginx, on le redemarre
	/usr/sbin/nginx -t
	if [ $? -eq 0 ];
	then
		/etc/init.d/nginx restart
	fi
fi


#!/bin/bash

#
#	christophe.borsenberger@vosprojetsweb.pro
#	
#	Install : ant, phpunit, PHP_CodeSniffer, phpcpd, PHP_Depend, PHPMD, PHPloc, PHP_CodeBrowser, phpDocumentor, PHP CS Fixer
#
#	syntax : wget -q -O - https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/devel-tools/php-qa-toolchain/setup.sh | sudo /bin/bash
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

### 1. On installe les paquets necessaires
LIST="ant php-pear graphviz"
displaytitle "-- Installation des paquets ${LISTE}"
$APT_GET install $LIST

### 2. Php PEAR
pear config-set auto_discover 1
pear list-upgrades
pear upgrade

### 3. PHPUnit
pear channel-discover pear.phpunit.de
pear install phpunit/PHPUnit

### 4. PHP_CodeSniffer
pear install PHP_CodeSniffer

### 5. PHP_Depend
pear channel-discover pear.pdepend.org
pear install pdepend/PHP_Depend

### 6. PHP_PMD
pear channel-discover pear.phpmd.org
pear install --alldeps phpmd/PHP_PMD

### 7. PHPLoc
pear install pear.phpunit.de/phploc

### 8. PHP_CodeBrowser
pear channel-discover pear.phpqatools.org
pear install --alldeps phpqatools/PHP_CodeBrowser

### 9. phpDocumentor
sudo pear channel-discover pear.phpdoc.org
sudo pear install phpdoc/phpDocumentor
	
### 10. php-cs-fixer
wget http://cs.sensiolabs.org/get/php-cs-fixer.phar -O /usr/local/bin/php-cs-fixer
chmod a+x /usr/local/bin/php-cs-fixer

### 11. phpCPD
pear install pear.phpunit.de/phpcpd

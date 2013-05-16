#!/bin/bash
set -e

# Test que le script est lance en root
if [ $EUID -ne 0 ]; then
  echo "Le script doit etre lance en root !" 1>&2
  exit 1
fi

# Configuration des outils
APT_GET="apt-get --yes"
WGET="wget -m --no-check-certificate"


### 1. On installe le nouveau fichier source.list de apt
SOURCES_LIST="https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/post-install/conf/sources.list"
cp /etc/apt/sources.list /etc/apt/sources.list-BACKUP
$WGET -O /etc/apt/sources.list $SOURCES_LIST

### 1.1 On installe les differentes cles des nouveaux depots
# http://www.dotdeb.org/instructions/
$WGET -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add -

# http://www.percona.com/doc/percona-server/5.5/installation/apt_repo.html
gpg --keyserver  hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
gpg -a --export CD2EFD2A | apt-key add -


### 2. On met a jour le systeme
$APT_GET update
$APT_GET upgrade


### 3. On installe les logiciels / binaires necessaires
$APT_GET install sudo debian-goodies vim logrotate

#!/bin/sh

#
#	Ce script permet de faire une sauvegarde d'un serveur web :
#		- base de données MySQL
#		- répertoire /etc
#		- répertoire /var/www
#
#	Script a installer sur la machine à sauvegarder, via la commande :
#		wget -O /usr/local/bin/server-backup.sh https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/backup/remote-backup-server.sh  
#

set -e

#Repertoire où seront stockées
BACKUP_DIR="/var/local/backup"

# make sure backup directory exists
[ ! -d "${BACKUP_DIR}" ] && mkdir -p "${BACKUP_DIR}"

# Backup MySQL
MYSQL_BACKUP_FILE="${BACKUP_DIR}/mysql.gz"
rm -f "${MYSQL_BACKUP_FILE}"
mysqldump -u YOUR_USER -p YOUR_PASSWORD --opt --all-databases --single-transaction | gzip -9 > "${MYSQL_BACKUP_FILE}"

# Backup /etc
ETC_BACKUP_FILE="${BACKUP_DIR}/etc.tar.gz"
rm -f "${ETC_BACKUP_FILE}"
/bin/tar -czf "${ETC_BACKUP_FILE}" /etc 

# Backup /var/www
WWW_BACKUP_FILE="${BACKUP_DIR}/www.tar.gz"
rm -f "${WWW_BACKUP_FILE}"
/bin/tar -czf "${WWW_BACKUP_FILE}" --exclude "log" --exclude "tmp" /var/www 

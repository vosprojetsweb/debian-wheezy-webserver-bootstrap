#!/bin/sh

#
#	Ce script permet de se connecter a un server distant,
#	de lancer la creation du backup et de le telecharger
#	
#	sudo wget --no-check-certificate -O /usr/local/bin/backup-server https://raw.github.com/vosprojetsweb/debian-wheezy-webserver-bootstrap/master/backup/local-backup-server.sh
#	sudo chmod 700 /usr/local/bin/backup-server 
#

set -e 

SSH_PORT=22
SSH_OPTIONS=""
SSH_USER="YOUR_BACKUP_USER"
SSH_HOST="HOST_TO_BACKUP"

DATE=`date +%Y.%m.%d_%H.%M.%S`
BACKUP_ROOT="/path/to/archives/"
BACKUP_DIR="${BACKUP_ROOT}/${HOST}/${DATE}"

[ ! -d "${BACKUP_DIR}" ] && mkdir -p "${BACKUP_DIR}"

# Creation du backup
echo "Creation du backup sur le serveur $SSH_HOST"
ssh -p $SSH_PORT $SSH_OPTIONS $SSH_USER@$SSH_HOST "sudo /usr/local/bin/backup-server"

# Telechargement des fichiers
echo "Telechargement des archives"
scp -P $SSH_PORT $SSH_OPTIONS $SSH_USER@$SSH_HOST:/var/local/backup/mysql.gz "${BACKUP_DIR}/mysql.gz"
scp -P $SSH_PORT $SSH_OPTIONS $SSH_USER@$SSH_HOST:/var/local/backup/etc.tar.gz "${BACKUP_DIR}/etc.tar.gz"
scp -P $SSH_PORT $SSH_OPTIONS $SSH_USER@$SSH_HOST:/var/local/backup/www.tar.gz "${BACKUP_DIR}/www.tar.gz"


# Suppression des anciens backups
echo "Suppression des anciennes archives"
find "${BACKUP_ROOT}" -mtime +7 -type d | xargs rm -rf

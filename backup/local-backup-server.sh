#!/bin/sh

#
#	Ce script permet de se connecter a un server distant,
#	de lancer la création du backup et de la telecharger 
#

SSH_PORT=22
USER="foo"
HOST="example.com"

BACKUP_DIR="/var/local/backup/${HOST}/${DATE}"

# Creation du backup
ssh -p $SSH_PORT $USER@$HOST /usr/local/bin/backup-server.sh

# Telechargement des fichiers
scp -P $SSH_PORT $USER@$HOST:"/var/local/backup/mysql.gz" "${BACKUP_DIR}/mysql.gz"
scp -P $SSH_PORT $USER@$HOST:"/var/local/backup/etc.gz" "${BACKUP_DIR}/etc.gz"
scp -P $SSH_PORT $USER@$HOST:"/var/local/backup/www.gz" "${BACKUP_DIR}/www.gz"
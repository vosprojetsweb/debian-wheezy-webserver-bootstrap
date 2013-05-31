#Principe

Une machine de backup se connecte au serveur à sauvegarder, crée les archives et les télécharges.

Etant donné que la machine de "backup" doit se connecter en ssh au "serveur", il faut [générer des clés ssh](https://help.github.com/articles/generating-ssh-keys).
On peut aussi créer un nouvel utilisateur qui aura comme seule responsabilité la création des archives. (ie : executer le script backup-server.sh)

*Creation du user bkp
adduser \
    --system \
    --shell /bin/bash \
    --group \
    --disabled-password \
    --home /var/local/backup \
    bkp

* On autorise bkp a se connecter en ssh
usermod -a -G sshusers bkp 
 
 
* un autorise bkp à exécuter le script /usr/local/bin/backup-server.sh en tant que root
bkp ALL=(root) NOPASSWD: /usr/local/bin/backup-server

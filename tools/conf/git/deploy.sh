#
# Etape de deploiement
#	Mise a jour des libs via composer
#	Mise a jour des sources
#	Mise a jour de la base de donnees
#

### Mise a jour des libs, via composer
# On le fait en premier, car cela peut prendre un certain tps 
EXPORT GIT_WORK_TREE=/var/www/__SERVER_NAME__
git checkout-index -f composer.json

cd $GIT_WORK_TREE
composer update

### Mise a jour des sources
cd /var/git/__SERVER_NAME__.git
git archive master | tar --overwrite -x -C $GIT_WORK_TREE

### TODO : Deploiement SQL
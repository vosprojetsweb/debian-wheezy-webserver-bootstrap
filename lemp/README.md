# LEMP : Linux Nginx MySQL PHP-FPM

# Nginx:

### Logs


# MySQL

### Logs




# PHP-FPM

### Configuration

##### FPM
http://www.php.net/manual/fr/install.fpm.configuration.php

1. Global
lemp/conf/php-fpm/php-fpm.conf => /etc/php5/fpm/php-fpm.conf


2. Pool
lemp/conf/php-fpm/pool-www.conf => /etc/php5/fpm/pool.d/www.conf


##### PHP
http://www.php.net/manual/en/ini.sections.php

Depuis PHP 5.3, on peut définir dans dans le fichier php.ini des sections, qui s'appliqueront en fonction du chemin, 
ou de l'hôte à partir duquel s'exécute le script PHP.

De plus, le répertoire /etc/php5/conf.d/ est scanné pour des fichiers de configurations supplémentaires, on peut donc 
créer un fichier par hôte, si l'on désire des configurations différentes. Le nom du fichier de configuration sera : $host.ini

lemp/conf/php-fpm/www.example.ini => /etc/php5/conf.d/www.example.ini


##### Nginx
On configure nginx afin qu'il passe à PHP-FPM toutes les requêtes php qu'il recoit.

lemp/conf/php-fpm/nginx-php-fpm.conf => /etc/nginx/conf.d/php-fpm.conf


### Logs

Tous les logs php se trouvent dans le répertoire /var/log/php5 : 

php_errors.log : log d'erreurs par défaut de php5
php5-fpm.log : log global de php-fpm
$pool-slow.log : log des requêtes pour le pool $pool
$host.errors.log : erreur pour l'application accessible via l'hôte $host 

Rotation des logs : tous les jours

lemp/conf/php-fpm/logrotate.conf => /etc/logrotate.d/php5-fpm
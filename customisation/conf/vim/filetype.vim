
#Nginx
au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif

#php-fpm
autocmd BufRead,BufNewFile /etc/php5/fpm/* set syntax=dosini

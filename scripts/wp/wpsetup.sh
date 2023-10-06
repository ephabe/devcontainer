source /.env

wp core download --locale=ja --path=/var/www/html

# cd /var/www/html/
# curl https://ja.wordpress.org/latest-ja.tar.gz > wp.tar.gz
# tar xzvf wp.tar.gz -C ./ --strip-components 1
# rm wp.tar.gz

mysql -h mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE $WP_DBNAME CHARACTER SET utf8mb4"

wp core config --dbname=$WP_DBNAME --dbuser=root --dbpass=$MYSQL_ROOT_PASSWORD --dbhost=mysql --dbprefix=wp_
wp core install --url=http://$WEB_HOST_NAME --title=$WP_DBNAME --admin_user=$WP_USERNAME --admin_password=$WP_PASSWORD --admin_email=wp@$WEB_HOST_NAME
cp /scripts/wp/wp.gitignore ./.gitignore
curl -L https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php > adminer.php
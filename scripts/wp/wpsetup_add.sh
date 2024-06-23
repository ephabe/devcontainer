source /.env

WP_THEME_NAME="$WP_DBNAME"

sed -i -e "s/webtemplatewp/$WP_THEME_NAME/" /var/www/html/wp-content/themes/$WP_THEME_NAME/style.css
wp theme activate $WP_THEME_NAME

wp plugin install classic-editor advanced-custom-fields query-monitor duplicate-post --activate

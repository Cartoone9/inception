#!/bin/bash

MYSQL_USER_PASS=$(cat /run/secrets/db_user_password)
WP_ADMIN_PASS=$(cat /run/secrets/wp_admin_password)
WP_USER_PASS=$(cat /run/secrets/wp_user_password)
WP_REDIS_USER_PASS=$(cat /run/secrets/redis_user_password)

# Download wp-cli if not present
[ ! -f /usr/local/bin/wp ] && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

cd /var/www/wordpress

# Only run wp install if not done yet
if [ ! -f /var/www/wordpress/wp-config.php ]; then
	cd /var/www/wordpress

	wp core download --allow-root
	wp core config --dbhost="$MYSQL_HOST" --dbname="$MYSQL_DB_NAME" --dbuser="$MYSQL_USER_NAME" --dbpass="$MYSQL_USER_PASS" --allow-root
	wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_NAME" --admin_password="$WP_ADMIN_PASS" --admin_email="$WP_ADMIN_EMAIL" --allow-root

	# Create the additional user if needed
	wp user create "$WP_USER_NAME" "$WP_USER_EMAIL" --role="$WP_USER_ROLE" --user_pass="$WP_USER_PASS" --allow-root

	# Install theme
	wp theme install bricksy --activate --allow-root

	chown -R www-data:www-data /var/www/wordpress
fi

# Redis setup
if ! wp plugin is-installed redis-cache --allow-root 2>/dev/null; then
	# Install and activate redis plugin
	wp plugin install redis-cache --activate --allow-root
fi

if ! wp config has WP_REDIS_HOST --allow-root 2>/dev/null; then
	# Config redis plugin
	wp config set WP_REDIS_HOST 'redis' --allow-root # hostname
	wp config set WP_REDIS_PASSWORD "$WP_REDIS_USER_PASS" --allow-root # password
	wp config set WP_REDIS_PORT 6379 --allow-root --raw # port
	wp config set WP_REDIS_DATABASE 0 --allow-root --raw # database value, up to 16 for multiple services
	wp config set WP_CACHE true --allow-root --raw # activate the plugin

	# Enable redis cache
	wp redis enable --allow-root
fi

# Start php-fpm in the forground
php-fpm8.2 -F

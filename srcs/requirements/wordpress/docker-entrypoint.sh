#!/bin/bash
set -e

WP_PATH="/var/www/html"

mkdir -p "$WP_PATH"
cd "$WP_PATH"

echo "Waiting for MariaDB..."

until mariadb-admin ping \
    -h"${WORDPRESS_DB_HOST%%:*}" \
    -u"${WORDPRESS_DB_USER}" \
    -p"${WORDPRESS_DB_PASSWORD}" \
    --silent
do
    sleep 2
done

echo "MariaDB is ready."


if [ ! -f index.php ]; then
    echo "Downloading WordPress..."

    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz --strip-components=1
    rm latest.tar.gz
fi


if [ ! -f wp-config.php ]; then

cat > wp-config.php <<EOF
<?php

define('DB_NAME', '${WORDPRESS_DB_NAME}');
define('DB_USER', '${WORDPRESS_DB_USER}');
define('DB_PASSWORD', '${WORDPRESS_DB_PASSWORD}');
define('DB_HOST', '${WORDPRESS_DB_HOST}');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

\$table_prefix = 'wp_';

define('WP_DEBUG', false);

if ( ! defined('ABSPATH') )
    define('ABSPATH', __DIR__ . '/');

require_once ABSPATH . 'wp-settings.php';
EOF

fi

if ! wp core is-installed --allow-root
then

    echo "Installing WordPress..."

    wp core install \
        --url="$WORDPRESS_URL" \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --allow-root

    echo "Creating user..."

    wp user create \
        "$WORDPRESS_USER" \
        "$WORDPRESS_USER_EMAIL" \
        --user_pass="$WORDPRESS_USER_PASSWORD" \
        --role=author \
        --allow-root

fi

chown -R www-data:www-data "$WP_PATH"

echo "Starting PHP-FPM..."

exec php-fpm8.2 -F
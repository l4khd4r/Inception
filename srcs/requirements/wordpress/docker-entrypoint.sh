#!/bin/bash

set -e

WP_PATH="/var/www/html"
mkdir -p "$WP_PATH"
cd "$WP_PATH"

echo "Waiting for MariaDB..."
until mariadb-admin ping --host="${WORDPRESS_DB_HOST%%:*}" --user="${WORDPRESS_DB_USER}" --password="${WORDPRESS_DB_PASSWORD}" --silent; do
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
    echo "Creating wp-config.php..."
cat > wp-config.php <<EOF
<?php
define('DB_NAME', '${WORDPRESS_DB_NAME}');
define('DB_USER', '${WORDPRESS_DB_USER}');
define('DB_PASSWORD', '${WORDPRESS_DB_PASSWORD}');
define('DB_HOST', '${WORDPRESS_DB_HOST}');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

define('WP_REDIS_HOST', '${REDIS_HOST}');
define('WP_REDIS_PORT', '${REDIS_PORT}');

\$table_prefix = 'wp_';
define('WP_DEBUG', false);

if ( ! defined('ABSPATH') )
    define('ABSPATH', __DIR__ . '/');

require_once ABSPATH . 'wp-settings.php';
EOF
fi

if ! wp --path="$WP_PATH" core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp --path="$WP_PATH" core install \
        --url="$WORDPRESS_URL" \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --allow-root

    wp --path="$WP_PATH" user create \
        "$WORDPRESS_USER" \
        "$WORDPRESS_USER_EMAIL" \
        --user_pass="$WORDPRESS_USER_PASSWORD" \
        --role=author \
        --allow-root
fi

# Safe Plugin Setup
if ! wp --path="$WP_PATH" plugin is-installed redis-cache --allow-root; then
    echo "Installing redis-cache plugin..."
    wp --path="$WP_PATH" plugin install redis-cache --activate --allow-root
fi

echo "Enabling Redis Cache..."
wp --path="$WP_PATH" redis enable --allow-root || true

chown -R www-data:www-data "$WP_PATH"
echo "Starting PHP-FPM..."
exec php-fpm8.2 -F
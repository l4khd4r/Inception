#!/bin/bash
set -e

echo "Starting MariaDB Server..."

echo "MYSQL_DATABASE: ${MYSQL_DATABASE}"
echo "MYSQL_USER: ${MYSQL_USER}"
echo "MYSQL_PASSWORD: ${MYSQL_PASSWORD}"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# start MariaDB in background
mariadbd-safe --datadir=/var/lib/mysql &
pid=$!

# wait until MariaDB is ready (IMPORTANT: no root password needed in your setup)
until mariadb-admin ping --silent; do
  sleep 1
done

# initialization guard (THIS is the important fix)
if [ ! -f /var/lib/mysql/.mariadb_initialized ]; then
    echo "First time initialization..."

    mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    touch /var/lib/mysql/.mariadb_initialized
    echo "Initialization done."
else
    echo "Already initialized, skipping setup."
fi

# keep container alive with MariaDB process
wait $pid
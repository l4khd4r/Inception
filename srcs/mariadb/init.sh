#!/bin/bash
set -e

echo "Starting MariaDB initialization..."

# Create the runtime directory
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Start a temporary MariaDB server (socket only)
mariadbd-safe --user=mysql --datadir=/var/lib/mysql --skip-networking &
pid=$!

# Wait until MariaDB is ready
timeout=30
until mariadb-admin ping --silent; do
    timeout=$((timeout - 1))

    if [ "$timeout" -le 0 ]; then
        echo "ERROR: MariaDB failed to start."
        exit 1
    fi

    sleep 1
done

# Run initialization only once
if [ ! -f /var/lib/mysql/.initialized ]; then
    echo "Performing first-time database initialization..."

    mariadb -u root << EOF 
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    touch /var/lib/mysql/.initialized
    echo "Database initialization complete."
else
    echo "Database already initialized. Skipping setup."
fi

# Stop the temporary server
mariadb-admin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
wait $pid

echo "Starting MariaDB..."

# Replace this script with the real MariaDB server (PID 1)
exec mariadbd-safe --user=mysql --datadir=/var/lib/mysql
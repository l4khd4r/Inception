#!/bin/bash
set -e 

echo "mariadbd is starting ..."
mkdir -p /run/mysqld 
chown mysql:mysql /run/mysqld

# CHECK FOR THE CORE SYSTEM DATABASE FOLDER INSTEAD
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "First Setup ... No database found. Initializing..."

    mariadb-install-db \
        --user=mysql \
        --datadir=/var/lib/mysql

    # Start a temporary server
    mariadbd \
        --user=mysql \
        --console \
        --datadir=/var/lib/mysql &
    TMP_PID=$!

    # wait until the server is ready 
    echo "Waiting for mariadbd to start ..."
    until mariadb-admin ping --silent >/dev/null 2>&1; do
        sleep 1
    done
    echo "mariadbd is ready ..."

mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    # Stop temporary server
    echo "Shutting down temporary server..."
    mariadb-admin -u root -p"${MARIADB_ROOT_PASSWORD}" shutdown
    wait "$TMP_PID"
else 
    echo "Database directory already exists, skipping initialization step..."
fi

exec mariadbd \
    --user=mysql \
    --console \
    --bind-address=0.0.0.0 \
    --datadir=/var/lib/mysql
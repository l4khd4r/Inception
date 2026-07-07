#!/bin/bash

set -e 

echo "mariadbd is starting ..."

mkdir -p /run/mysqld 

chown mysql:mysql /run/mysqld



if [ ! -d "/var/lib/mysql/mysql/.initialized" ]  ; then
    echo "First Setup ..."

    rm -rf /var/lib/mysql/*

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
    until mariadb-admin ping  --silent >/dev/null 2>&1; do
        sleep 1
    done
    echo "mariadbd is ready ..."


mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';

GRANT ALL PRIVILEGES
ON \`${MARIADB_DATABASE}\`.*
TO '${MARIADB_USER}'@'%';

ALTER USER 'root'@'localhost'
IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';

FLUSH PRIVILEGES;
EOF

    # Stop temporary server
    mariadb-admin -u root -p"${MARIADB_ROOT_PASSWORD}" shutdown
    
    touch /var/lib/mysql/mysql/.initialized
    wait "$TMP_PID"
else 
        echo "Database already exists, skipping setup ..."
fi

exec mariadbd \
    --user=mysql \
    --console \
    --bind-address=0.0.0.0 \
    --datadir=/var/lib/mysql

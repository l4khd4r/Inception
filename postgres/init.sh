#!/bin/bash
set -e

echo "Initializing database..."

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<EOSQL
    CREATE DATABASE testdb;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname testdb < /docker-entrypoint-initdb.d/02-schema.sql

echo "Database initialized."
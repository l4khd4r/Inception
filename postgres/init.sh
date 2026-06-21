#!/bin/bash
set -e

echo "Initializing testdb..."

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE testdb;
EOSQL

echo "Database testdb created."
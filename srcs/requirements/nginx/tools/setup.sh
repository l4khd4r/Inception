#!/bin/bash

set -e

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -subj "/C=MA/ST=BENGUERIR/L=BENGUERIR/O=1337/OU=1337/CN=mlakhdar.42.fr" \
    -keyout /etc/nginx/ssl/mlakhdar.42.fr.key \
    -out /etc/nginx/ssl/mlakhdar.42.fr.crt
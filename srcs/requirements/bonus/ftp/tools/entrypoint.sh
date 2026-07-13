#!/bin/bash
set -e

mkdir -p /var/run/vsftpd/empty
mkdir -p /var/www/html

if ! id "$FTP_USER" >/dev/null 2>&1; then
    useradd -m -d /var/www/html -s /bin/bash "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

chown -R "$FTP_USER:$FTP_USER" /var/www/html

echo "Starting vsftpd..."
exec /usr/sbin/vsftpd /etc/vsftpd.conf
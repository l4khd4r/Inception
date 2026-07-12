#!/bin/bash


mkdir -p /var/run/vsftpd/empty

# Create a system user for FTP if it doesn't exist
if [ ! -d "/home/$FTP_USER" ]; then
    
    useradd -d /var/www/html -s /usr/sbin/bash "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    
    chown -R "$FTP_USER:$FTP_USER" /var/www/html
fi

echo "FTP Server starting..."
exec /usr/sbin/vsftpd /etc/vsftpd.conf
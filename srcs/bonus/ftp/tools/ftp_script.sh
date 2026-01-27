#!/bin/bash

FTP_USER_PASS=$(cat /run/secrets/ftp_user_password)

# Make the jail directory
mkdir -p /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd/empty

# Create FTP user
useradd -d /var/www/wordpress $FTP_USER_NAME

# Change password
echo -e "$FTP_USER_PASS\n$FTP_USER_PASS" | passwd $FTP_USER_NAME

# Run the FTP server as PID1
exec vsftpd /etc/vsftpd.conf

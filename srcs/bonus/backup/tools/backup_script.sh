#!/bin/bash

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=/backups

# Backup wordpress
tar -czf $BACKUP_DIR/wordpress_$DATE.tar.gz /var/www/wordpress

# Backup mariadb
mysqldump -h mariadb -u $MYSQL_USER_NAME -p$MYSQL_USER_PASS $MYSQL_DB_NAME > $BACKUP_DIR/db_$DATE.sql

# Keep only 7 most recent backups for each
ls -t $BACKUP_DIR/wordpress_*.tar.gz | tail -n +8 | xargs -r rm
ls -t $BACKUP_DIR/db_*.sql | tail -n +8 | xargs -r rm

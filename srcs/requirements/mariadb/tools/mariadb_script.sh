#!/bin/bash

# Check for secrets
if [ ! -f /run/secrets/db_user_password ] || [ ! -f /run/secrets/db_root_password ]; then
	echo "Secrets not found! Stopping."
	sleep 5
	exit 1
fi

MYSQL_USER_PASS=$(cat /run/secrets/db_user_password)
MYSQL_ROOT_PASS=$(cat /run/secrets/db_root_password)

# fix issues where localhost is expected not mariadb
unset MYSQL_HOST

# Start a temporary MariaDB server specifically for initialization
# --skip-networking: No outside connections allowed during setup (security)
# & : Runs in background
echo "Starting temporary MariaDB..."
mysqld_safe --skip-networking &
pid=$!

# 4. Wait for MariaDB to be ready
for i in {1..10}; do
	if mysqladmin ping --silent; then
		echo "MariaDB is responding."
		break
	fi
	echo "Waiting for MariaDB... ($i/10)"
	sleep 1
done

# 5. Database Initialization Logic
if [ -d "/var/lib/mysql/${MYSQL_DB_NAME}" ]; then 
	echo "Database ${MYSQL_DB_NAME} already exists. Skipping initialization."
else
	# Create DB and User
	mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB_NAME}\`;"
	mariadb -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER_NAME}\`@'%' IDENTIFIED BY '${MYSQL_USER_PASS}';"
	mariadb -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DB_NAME}\`.* TO \`${MYSQL_USER_NAME}\`@'%';"
	mariadb -e "FLUSH PRIVILEGES;"

	# Set Root Password
	mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';"

	echo "Database initialized."
fi

# Shutdown
mysqladmin -u root -p"${MYSQL_ROOT_PASS}" shutdown

# Wait for the background process to actually exit
wait "$pid" 2>/dev/null

echo "Starting MariaDB in foreground..."

exec mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'

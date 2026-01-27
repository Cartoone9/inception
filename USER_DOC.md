# User Documentation

## Table of Contents

- [Services Overview](#services-overview)
- [Starting and Stopping](#starting-and-stopping)
- [Accessing Services](#accessing-services)
- [Environment](#environment)
- [Credentials](#credentials)
- [Checking Services Status](#checking-services-status)

## Services Overview

This stack provides:

| Service | Description | Access |
|---------|-------------|--------|
| Nginx | Reverse proxy | Handles all HTTPS requests |
| Wordpress | Main website with CMS | https://user.42.fr |
| MariaDB | Database (internal only) | Not directly accessible |
| Adminer | Database management GUI | https://user.42.fr/adminer |
| Redis | Cache (internal only) | Not directly accessible |
| FTP | File access to Wordpress | ftp://user.42.fr:21 |
| Backup | Automated backups | Runs automatically via cron |
| Static Site | Personal static website | https://user.42.fr/static |


## Starting and Stopping

### Start the stack

```bash
make
```

### Stop the stack

```bash
make down
```

### Restart services

```bash
make restart
```

### Full rebuild

```bash
make re
```

## Accessing Services

### Wordpress Website

Open a browser and go to:
```
https://user.42.fr
```

### Wordpress Admin Panel

```
https://user.42.fr/wp-admin
```

### Adminer (Database)

```
https://user.42.fr/adminer
```
Select MariaDB, use `mariadb` as server, and enter database credentials.

### Static Website

```
https://user.42.fr/static
```

### FTP

Connect with any FTP client (like Filezilla):
- Host: `user.42.fr`
- Username: see environment below
- Password: see credentials below
- Port: `21`

## Environment

Can be found in the `srcs/` folder:

```
# --- MariaDB --- #

MYSQL_HOST= mariadb
MYSQL_DB_NAME= my_database
MYSQL_USER_NAME= db_user
#MYSQL_USER_PASS= stored in secrets
#MYSQL_ROOT_PASS= stored in secrets

# --- Wordpress --- #

DOMAIN_NAME= user.42.fr
WP_TITLE= my_wordpress

WP_ADMIN_NAME= groot
WP_ADMIN_EMAIL= groot@email.com
#WP_ADMIN_PASS= stored in secrets

WP_USER_NAME= wp_user
WP_USER_EMAIL= wp_user@email.com
WP_USER_ROLE= author
#WP_USER_PASS= stored in secrets

# --- Vsftp --- #

FTP_USER_NAME= ftp_user
#FTP_USER_PASS= stored in secrets
```

## Credentials

Credentials are stored in the `secrets/` folder:

| File | Purpose |
|------|---------|
| `db_root_password.txt` | MariaDB root password |
| `db_user_password.txt` | MariaDB user password |
| `wp_admin_password.txt` | Wordpress admin password |
| `wp_user_password.txt` | Wordpress user password |
| `ftp_user_password.txt` | FTP user password |

To view a credential:
```bash
cat secrets/db_user_password.txt
```

**Note:** These files should not be committed to git. They must be in the `.gitignore`.

When setting up the project for the first time, set up the environment in `srcs/.env` using the example above, then create the `secrets/` folder and add your own password files.

## Checking Services Status

### View running containers

```bash
make ps
```

It also let you check containers health.

To see the static container status, go in `srcs/` and use `docker ps -a`.

### Check container logs

```bash
docker logs <container_name>
```

Examples:
```bash
docker logs nginx
docker logs wp_php
docker logs mariadb
```

### Check Wordpress plugins

```bash
# List Wordpress plugins
make plugins

# Or manually
docker exec -it wp_php wp plugin list --path=/var/www/wordpress --allow-root
```

Or look in the Wordpress Admin Panel directly via `https://user.42.fr/wp-admin`.

# Developer Documentation

## Table of Contents

- [Setting Up the Environment](#setting-up-the-environment)
- [Building and Launching](#building-and-launching)
- [Managing Containers and Volumes](#managing-containers-and-volumes)
- [Data Storage and Persistence](#data-storage-and-persistence)
- [Project Structure](#project-structure)

## Setting Up the Environment

### Prerequisites

- A Virtual Machine or VPS running Linux (Debian/Ubuntu recommended)
- Docker Engine
- Docker Compose
- Make

### Installation

1. **Install Docker**
```bash
sudo apt update
sudo apt install docker.io docker-compose-v2
sudo systemctl enable docker
sudo systemctl start docker
```

2. **Add your user to docker group** (to run without sudo)
```bash
sudo usermod -aG docker $USER
newgrp docker
```

3. **Clone the repository**
```bash
git clone https://github.com/Cartoone9/inception
cd inception
```

### Configuration Files

| File | Location | Purpose |
|------|----------|---------|
| `docker-compose.yml` | `srcs/` | Defines all services, networks, volumes |
| `.env` | `srcs/` | Environment variables (usernames, domain, etc.) |
| `nginx.conf` | `srcs/requirements/nginx/conf/` | NGINX configuration |
| `www.conf` | `srcs/requirements/wordpress/conf/` | PHP-FPM pool config |
| `redis.conf` | `srcs/bonus/redis/conf/` | Redis configuration |
| `vsftpd.conf` | `srcs/bonus/ftp/conf/` | FTP server configuration |

### Environment Setup

Create `srcs/.env` and fill in the environment variables using the example below.

```bash
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

Make sure `srcs/.env` is in your `.gitignore`.

### Secrets Setup

Create the `secrets/` folder at the project root and add password files:

```bash
mkdir -p secrets
echo "your_db_root_password" > secrets/db_root_password.txt
echo "your_db_user_password" > secrets/db_user_password.txt
echo "your_wp_admin_password" > secrets/wp_admin_password.txt
echo "your_wp_user_password" > secrets/wp_user_password.txt
echo "your_ftp_user_password" > secrets/ftp_user_password.txt
```

Make sure `secrets/` is in your `.gitignore`.

### Domain Configuration

Add your domain to `/etc/hosts`:
```bash
echo "127.0.0.1 user.42.fr" | sudo tee -a /etc/hosts
```

## Building and Launching

### First Launch

```bash
make
```

Which equates to:

```bash
mkdir -p /home/user/data/mariadb \
&& mkdir -p /home/user/data/wordpress \
&& mkdir -p /home/user/data/backup

docker compose -f srcs/docker-compose.yml up -d
```

This creates the data directories and starts all containers.

### Rebuild Images

```bash
make build
```

### Full Rebuild (clean + build)

```bash
make re
```

## Managing Containers and Volumes

### Makefile Docker Commands

| Command | Description |
|---------|-------------|
| `make` | Create dirs and start containers |
| `make build` | Build/rebuild images and start |
| `make restart` | Restart services |
| `make down` | Stop containers |
| `make re` | Full rebuild (fclean + build) |
| `make clean` | Stop containers and remove volumes |
| `make fclean` | Clean + prune dangling volumes |

### Useful Docker Commands

```bash
# View logs for a specific container
docker logs <container_name>
docker logs -f nginx  # follow mode

# Enter a container shell
docker exec -it <container_name> sh
docker exec -it wp_php bash

# Inspect a container
docker inspect <container_name>

# List containers
docker ps
# or
docker ps -a # to see all containers, running or stopped

# List networks
docker network ls

# List volumes
docker volume ls
```

### Wordpress CLI

```bash
# List Wordpress plugins
make plugins

# Or manually
docker exec -it wp_php wp plugin list --path=/var/www/wordpress --allow-root
```

Or look in the Wordpress Admin Panel directly via `https://user.42.fr/wp-admin`.

## Data Storage and Persistence

### Volume Locations

| Volume | Host Path | Container Path | Purpose |
|--------|-----------|----------------|---------|
| `db_data` | `/home/user/data/mariadb` | `/var/lib/mysql` | Database files |
| `wp_data` | `/home/user/data/wordpress` | `/var/www/wordpress` | Wordpress files |
| `backup_data` | `/home/user/data/backup` | `/backups` | Backup archives |
| `static_data` | Docker-managed | `/var/www/static` | Static site files |

### How Persistence Works

- `db_data`, `wp_data`, and `backup_data` use bind mounts to host directories.
- Data survives `make down` and `make restart`.
- `make clean` removes Docker volumes but bind mount data (`mariadb`, `wordpress`, `backup`) persists on host.
- Only `static_data` is lost since it's Docker-managed.

### Backup Location

Automated backups are stored in `/home/user/data/backup/` and run via cron inside the backup container.

## Project Structure

```
inception/
├── Makefile
├── secrets/                    # Not committed
│   ├── db_root_password.txt    # Not committed
│   ├── db_user_password.txt    # Not committed
│   ├── wp_admin_password.txt   # Not committed
│   ├── wp_user_password.txt    # Not committed
│   └── ftp_user_password.txt   # Not committed
└── srcs/
    ├── .env                    # Not committed
    ├── docker-compose.yml
    ├── requirements/
    │   ├── mariadb/
    │   │   ├── Dockerfile
    │   │   └── tools/
    │   ├── nginx/
    │   │   ├── Dockerfile
    │   │   └── conf/
    │   └── wordpress/
    │       ├── Dockerfile
    │       ├── conf/
    │       └── tools/
    └── bonus/
        ├── adminer/
        ├── backup/
        ├── ftp/
        ├── redis/
        └── static/
```

COMPOSE = docker compose -f srcs/docker-compose.yml

DATADIR = /home/user/data
MKDIR = mkdir -p $(DATADIR)/mariadb $(DATADIR)/wordpress $(DATADIR)/backup

all:
	$(MKDIR)
	$(COMPOSE) up -d

build:
	$(MKDIR)
	$(COMPOSE) up --build -d

restart:
	$(COMPOSE) restart

down:
	$(COMPOSE) down

re:
	$(MAKE) fclean
	$(MAKE) build

clean:
	$(COMPOSE) down -v

fclean:
	$(MAKE) clean
	docker volume prune -f

ps:
	$(COMPOSE) ps

plugins:
	docker exec -it wp_php wp plugin list --path=/var/www/wordpress --allow-root

.PHONY: all build restart down re clean fclean ps plugins

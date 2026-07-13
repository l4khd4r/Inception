NAME        = inception
COMPOSE     = srcs/docker-compose.yml
COMPOSE_CMD = docker compose -f $(COMPOSE)

DATA_DIR    = $(HOME)/data
WP_DATA     = $(DATA_DIR)/wordpress
DB_DATA     = $(DATA_DIR)/mariadb

all: up

up: directories
	$(COMPOSE_CMD) up -d --build

build:
	$(COMPOSE_CMD) build

start:
	$(COMPOSE_CMD) start

stop:
	$(COMPOSE_CMD) stop

down:
	$(COMPOSE_CMD) down

logs:
	$(COMPOSE_CMD) logs -f

ps:
	$(COMPOSE_CMD) ps

restart: down up

directories:
	mkdir -p $(WP_DATA)
	mkdir -p $(DB_DATA)

clean:
	$(COMPOSE_CMD) down --remove-orphans

fclean: clean
	docker system prune -af --volumes

re: fclean all

.PHONY: all up build start stop down logs ps restart directories clean fclean re
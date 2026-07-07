build :
	mkdir -p /home/mlakhdar/data/wordpress
	mkdir -p /home/mlakhdar/data/mariadb
	docker compose -f srcs/docker-compose.yml build  

down :
	docker compose -f srcs/docker-compose.yml down

up :
	docker compose -f srcs/docker-compose.yml up -d

downv:
	docker compose -f srcs/docker-compose.yml down -v


image:
	docker rmi $(docker images -q)

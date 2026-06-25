

down : 
	docker compose down -v --remove-orphans

up :
	docker compose up -d --build 

rmstopedcontainer :
	docker rm $(docker ps -a -q)

rmstopedimage :
	docker rmi $(docker images -q)

rmimages:
	docker rmi $(docker images -q) -f


logs:
	docker compose logs -f

networkls:
	docker network ls

rmnetwork:
	docker network rm app-network
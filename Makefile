

down : 
	docker compose down -v --remove-orphans

up :
	docker compose up -d --build 
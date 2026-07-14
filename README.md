# Inception

> *This project has been created as part of the 42 curriculum by
> mlakhdar.*

## Description

Inception is a System Administration project from the 42 curriculum
focused on building a production-like web infrastructure using Docker
and Docker Compose. Every service runs in its own Debian Bookworm
container and communicates over an isolated Docker network. Persistent
data is stored using Docker named volumes.

### Infrastructure

-   NGINX (TLS 1.2/1.3)
-   WordPress + PHP-FPM
-   MariaDB
-   Redis (bonus)
-   FTP server (bonus)
-   Adminer (bonus)
-   cAdvisor (bonus)
-   Static Website (bonus)

## Repository Layout

``` text
.
├── Makefile
└── srcs
    ├── docker-compose.yml
    └── requirements
        ├── mariadb
        ├── nginx
        ├── wordpress
        └── bonus
            ├── adminer
            ├── cadvisor
            ├── ftp
            ├── redis
            └── static_website
```

## Architecture

``` mermaid
flowchart TD
Browser-->NGINX
NGINX-->WordPress
WordPress-->MariaDB
WordPress-->Redis
FTP-->WordPress
Adminer-->MariaDB
cAdvisor-->Docker
```

## Services

### NGINX

-   Single public entry point.
-   HTTPS only.
-   Reverse proxy for PHP-FPM.

### WordPress

-   Runs PHP-FPM.
-   Application files stored in a persistent volume.
-   Connects to MariaDB and Redis.

### MariaDB

-   Dedicated database container.
-   Persistent database volume.

### Redis

-   Object cache for WordPress.

### FTP

-   Access to the WordPress volume.

### Adminer

-   Database administration interface.

### cAdvisor

-   Docker container monitoring.

### Static Website

-   Demonstrates serving additional content.

## Build

``` bash
make
```

## Useful Commands

``` bash
make
make up
make down
make clean
docker compose ps
docker compose logs
docker compose exec nginx bash
docker volume ls
docker network ls
```

## Data Persistence

Two Docker named volumes persist: - WordPress files - MariaDB database

## Networking

All services communicate through a dedicated Docker bridge network. Only
NGINX exposes port 443.

## Security

-   HTTPS enabled.
-   Environment variables used for configuration.
-   Credentials should never be committed.
-   Dedicated containers for every service.

## Design Choices

### Virtual Machine vs Docker

  VM                Docker
  ----------------- ---------------
  Full OS           Shared kernel
  Higher overhead   Lightweight
  Slower startup    Fast startup

### Secrets vs Environment Variables

Environment variables are convenient for configuration. Docker Secrets
provide stronger protection for sensitive credentials.

### Docker Network vs Host Network

A bridge network isolates containers while allowing controlled
communication. Host networking removes isolation.

### Volumes vs Bind Mounts

Named volumes are managed by Docker and ideal for persistent application
data. Bind mounts map host directories directly and are better suited to
development.

## AI Usage

AI was used to: - Review Docker concepts. - Explain networking. -
Improve documentation. - Brainstorm architecture.

All implementation, debugging, testing, and final validation were
manually reviewed and understood.

## Learning Outcomes

-   Docker
-   Docker Compose
-   Reverse proxies
-   TLS
-   PHP-FPM
-   MariaDB
-   Container networking
-   Persistent storage
-   Linux system administration

## Resources

-   https://docs.docker.com
-   https://nginx.org
-   https://mariadb.org
-   https://wordpress.org
-   https://redis.io
-   https://www.php.net

## License

Educational project for the 42 curriculum.

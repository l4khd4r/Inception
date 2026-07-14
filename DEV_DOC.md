# DEV_DOC.md

# Developer Documentation

## Purpose

This document explains how to build, configure, debug, and maintain the
Inception project.

## Project Overview

The infrastructure is composed of isolated Debian-based Docker
containers orchestrated with Docker Compose.

Services:

-   nginx
-   wordpress (PHP-FPM)
-   mariadb
-   redis
-   ftp
-   adminer
-   cadvisor
-   static website

------------------------------------------------------------------------

# Prerequisites

Install:

-   Docker Engine
-   Docker Compose
-   GNU Make

Recommended:

-   Debian 12 VM
-   Git

------------------------------------------------------------------------

# Repository Structure

``` text
Makefile
srcs/
    docker-compose.yml
    requirements/
```

Each service has its own Dockerfile.

------------------------------------------------------------------------

# Environment Configuration

Create a `.env` file containing:

-   DOMAIN_NAME
-   MYSQL_DATABASE
-   MYSQL_USER
-   MYSQL_PASSWORD
-   MYSQL_ROOT_PASSWORD
-   WORDPRESS_ADMIN_USER
-   WORDPRESS_ADMIN_PASSWORD
-   WORDPRESS_USER
-   WORDPRESS_USER_PASSWORD
-   FTP credentials
-   Redis settings (if required)

Never commit secrets.

------------------------------------------------------------------------

# Build

``` bash
make
```

This builds every image locally.

------------------------------------------------------------------------

# Start

``` bash
make up
```

or

``` bash
docker compose -f srcs/docker-compose.yml up -d
```

------------------------------------------------------------------------

# Stop

``` bash
make down
```

------------------------------------------------------------------------

# Remove Everything

``` bash
make clean
```

Remove unused objects:

``` bash
docker system prune -a
```

------------------------------------------------------------------------

# Useful Commands

List containers

``` bash
docker compose ps
```

Logs

``` bash
docker compose logs
```

Specific logs

``` bash
docker compose logs nginx
```

Enter container

``` bash
docker compose exec nginx bash
```

Images

``` bash
docker images
```

Volumes

``` bash
docker volume ls
```

Networks

``` bash
docker network ls
```

Inspect

``` bash
docker inspect <container>
```

------------------------------------------------------------------------

# Development Workflow

1.  Modify configuration.
2.  Rebuild image if Dockerfile changes.
3.  Restart affected service.
4.  Verify logs.
5.  Test functionality.

------------------------------------------------------------------------

# Persistent Data

MariaDB uses a Docker named volume.

WordPress files use another named volume.

Deleting containers does not remove volumes.

------------------------------------------------------------------------

# Networking

Containers communicate through an isolated Docker bridge network.

Only NGINX exposes HTTPS.

Services communicate internally using service names.

------------------------------------------------------------------------

# Container Responsibilities

## nginx

-   TLS termination
-   Reverse proxy
-   Static files

## wordpress

-   PHP-FPM
-   WordPress installation

## mariadb

-   Database initialization
-   Persistent storage

## redis

-   Object cache

## ftp

-   File transfer

## adminer

-   Database management

## cadvisor

-   Container monitoring

------------------------------------------------------------------------

# Debugging

Restart one service

``` bash
docker compose restart wordpress
```

Follow logs

``` bash
docker compose logs -f
```

Shell

``` bash
docker compose exec mariadb bash
```

Database

``` bash
mysql -u root -p
```

------------------------------------------------------------------------

# Common Problems

## NGINX returns 502

Check:

-   PHP-FPM running
-   FastCGI configuration

## WordPress cannot connect to MariaDB

Verify:

-   credentials
-   service name
-   network

## Redis not working

Check plugin configuration.

## FTP login fails

Verify:

-   user exists
-   volume mounted
-   passive ports

------------------------------------------------------------------------

# Makefile

Typical targets:

-   make
-   make up
-   make down
-   make clean
-   make re

------------------------------------------------------------------------

# Docker Best Practices

-   One service per container.
-   No latest tags.
-   No passwords in Dockerfiles.
-   Use environment variables.
-   Keep containers stateless.
-   Store persistent data in Docker volumes.

------------------------------------------------------------------------

# Validation Checklist

-   Images build locally.
-   HTTPS works.
-   WordPress loads.
-   MariaDB persists.
-   Redis active.
-   FTP works.
-   Adminer connects.
-   cAdvisor reachable.
-   No hardcoded credentials.

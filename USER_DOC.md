# USER_DOC.md

# User Documentation

## Purpose

This document explains how to use, manage, and verify the Inception
infrastructure as an end user or evaluator.

------------------------------------------------------------------------

# Overview

The Inception stack provides a complete web infrastructure built with
Docker.

## Available Services

  Service          Description
  ---------------- --------------------------------------------
  NGINX            HTTPS reverse proxy and public entry point
  WordPress        Website and content management system
  MariaDB          Database used by WordPress
  Redis            WordPress object cache
  FTP              Remote access to WordPress files
  Adminer          Web interface for MariaDB
  cAdvisor         Container monitoring dashboard
  Static Website   Additional static web content

------------------------------------------------------------------------

# Starting the Project

From the repository root:

``` bash
make
```

This command builds the Docker images and starts the infrastructure.

You can also use:

``` bash
make up
```

------------------------------------------------------------------------

# Stopping the Project

To stop the containers:

``` bash
make down
```

To stop and remove all containers, images, networks, and volumes
(depending on your Makefile implementation):

``` bash
make clean
```

------------------------------------------------------------------------

# Accessing the Website

## Main Website

Open your browser and navigate to:

``` text
https://mlakhdar.42.fr
```

Example:

``` text
https://mlakhdar.42.fr
```

Make sure your `/etc/hosts` file contains:

``` text
127.0.0.1 mlakhdar.42.fr
```

Replace `mlakhdar` with your own 42 login if necessary.

------------------------------------------------------------------------

# WordPress Administration Panel

Access the WordPress dashboard:

``` text
https://mlakhdar.42.fr/wp-admin
```

Login using the administrator credentials defined in your `.env` file.

------------------------------------------------------------------------

# Adminer Access

Adminer allows database administration through the browser.

Example URL:

``` text
http://localhost:8080
```

If Adminer is exposed on a separate route or port in your
implementation, use the appropriate address.

Use the following information:

-   System: MariaDB
-   Server: mariadb
-   Username: defined in `.env`
-   Password: defined in `.env`
-   Database: defined in `.env`

------------------------------------------------------------------------

# FTP Access

FTP allows direct access to WordPress files.

Example connection:

``` text
Host: mlakhdar.42.fr or localhost
Port: 21
Protocol: FTP
Encryption: Explicit FTP over TLS (if configured)
Username: defined in .env
Password: defined in .env
```

Recommended clients:

-   FileZilla
-   WinSCP
-   lftp

------------------------------------------------------------------------

# cAdvisor Monitoring

Access the monitoring interface to inspect running containers, CPU
usage, memory usage, and network statistics.


``` text
http://localhost:8081
```

------------------------------------------------------------------------

# Static Website

the bonus static website is enabled, access it using the configured
path or subdomain defined in the NGINX configuration.


``` text
https://mlakhdar.42.fr/portfolio
```


------------------------------------------------------------------------

# Credentials Management

All credentials are stored in the `.env` file.

Typical values include:

-   WordPress administrator username
-   WordPress administrator password
-   WordPress user credentials
-   MariaDB user and password
-   MariaDB root password
-   FTP credentials

Never commit `.env` files or secrets to Git.

------------------------------------------------------------------------

# Verifying Services

## Check running containers

``` bash
docker compose -f srcs/docker-compose.yml ps
```

Expected services:

-   nginx
-   wordpress
-   mariadb
-   redis
-   ftp
-   adminer
-   cadvisor

------------------------------------------------------------------------

## Check logs

All logs:

``` bash
docker compose -f srcs/docker-compose.yml logs
```

Specific service:

``` bash
docker compose -f srcs/docker-compose.yml logs nginx
```

Follow logs:

``` bash
docker compose -f srcs/docker-compose.yml logs -f
```

------------------------------------------------------------------------

# Common Tasks

## Restart a service

``` bash
docker compose -f srcs/docker-compose.yml restart wordpress
```

## Enter a container shell

``` bash
docker compose -f srcs/docker-compose.yml exec wordpress bash
```

## List volumes

``` bash
docker volume ls
```

## List networks

``` bash
docker network ls
```

------------------------------------------------------------------------

# Troubleshooting

## Website not accessible

Check:

-   NGINX container is running
-   Port 443 is exposed
-   `/etc/hosts` is configured correctly
-   TLS certificate was generated

------------------------------------------------------------------------

## WordPress setup page appears repeatedly

Check:

-   MariaDB is running
-   Database credentials are correct
-   WordPress volume permissions

------------------------------------------------------------------------

## 502 Bad Gateway

Verify:

-   PHP-FPM is running
-   NGINX FastCGI configuration is correct

------------------------------------------------------------------------

## FTP cannot connect

Check:

-   FTP container status
-   Passive ports configuration
-   Firewall settings
-   User credentials

------------------------------------------------------------------------

## Redis cache not working

Verify:

-   Redis container is running
-   WordPress Redis plugin is enabled
-   Redis host is set to `redis`

------------------------------------------------------------------------

# Useful Commands

``` bash
make
make up
make down
make clean
make re
```

------------------------------------------------------------------------

# Conclusion

This document is intended to help evaluators, administrators, and end
users quickly understand how to operate the Inception infrastructure and
verify that all services are functioning correctly.

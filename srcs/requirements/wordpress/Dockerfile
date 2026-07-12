FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-redis \
    php-zip \
    mariadb-client \
    wget \
    redis-tools \
    curl \
    tar \
    unzip \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    -O /usr/local/bin/wp \
 && chmod +x /usr/local/bin/wp

RUN rm /etc/php/8.2/fpm/pool.d/www.conf

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
FROM debian:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# allow remote connections (WordPress container)
RUN sed -i 's/bind-address.*/bind-address = 0.0.0.0/' \
    /etc/mysql/mariadb.conf.d/50-server.cnf

COPY init.sh /init.sh
RUN chmod +x /init.sh


ENTRYPOINT ["/init.sh"]


EXPOSE 3306

FROM debian:bookworm

RUN apt update && \
    apt install -y mariadb-server && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*


RUN sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' \
        /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh


ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
FROM postgres:18

COPY init.sh /docker-entrypoint-initdb.d/init.sh
COPY schema.sql /docker-entrypoint-initdb.d/02-schema.sql
COPY postgresql.conf /etc/postgresql/postgresql.conf

RUN chmod +x /docker-entrypoint-initdb.d/init.sh

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
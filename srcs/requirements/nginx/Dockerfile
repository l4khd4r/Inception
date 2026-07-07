FROM debian:bookworm

RUN apt update && \
    apt install -y nginx openssl && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/setup.sh /tmp/setup.sh

RUN chmod +x /tmp/setup.sh && \
    /tmp/setup.sh && \
    rm /tmp/setup.sh

CMD ["nginx", "-g", "daemon off;"]
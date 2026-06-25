FROM debian:latest

RUN apt-get update && apt-get install -y mariadb-server 


COPY init.sh /init.sh

RUN chmod +x /init.sh


CMD ["/bin/bash" , "/init.sh"]





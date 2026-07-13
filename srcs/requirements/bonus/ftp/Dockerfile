FROM debian:bookworm



RUN apt-get update && apt-get install -y \
    vsftpd \
    passwd \
    libpam0g





COPY ./conf/vsftpd.conf /etc/vsftpd.conf



COPY ./tools/entrypoint.sh /entrypoint.sh


EXPOSE 21 30000-30009

RUN chmod +x /entrypoint.sh


CMD ["/entrypoint.sh"]
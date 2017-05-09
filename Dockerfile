FROM debian:sid-slim

LABEL maintainer="Luca 'meti' P <github@lplab.net>" \
      version="0.0.1b"

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install wget procps manpages net-tools && \
    apt-get clean

ENV TINI_VERSION v0.14.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ADD install.sh /install.sh
RUN chmod +x /install.sh && /install.sh

ADD entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

#VOLUME ["/etc/pihole", "/var/log"]

EXPOSE 53 53/udp
EXPOSE 80

ENTRYPOINT ["/tini", "--"]

CMD ["/sbin/entrypoint.sh"]

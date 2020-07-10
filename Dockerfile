ARG ARCH=amd64/
FROM ${ARCH}alpine:latest
MAINTAINER webhainaut <jerome@webhainaut.be>

ENV HOST=""
ENV LOGIN=""
ENV PASSWORD=""
ENV ENTRYPOINT="https://www.ovh.com/nic/update"
ENV NSSERVER="8.8.8.8"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk --no-cache update \
    && apk --no-cache upgrade \
    && apk add --no-cache \
        curl \
        wget \
        curl \
        bash \
        zip \
        dcron \
        bind-tools \
        ca-certificates \
    && mkdir -p /srv/dyndns

COPY config /srv/dyndns/cmd.sh
COPY config /srv/dyndns/entrypoint.sh
COPY config /srv/dyndns/dynhost
COPY config /etc/cron.d/dynhost

RUN chmod +x /srv/dyndns/dynhost \
    && chmod +x /srv/dyndns/entrypoint.sh \
    && chmod +x /srv/dyndns/cmd.sh

HEALTHCHECK --interval=5s --timeout=3s CMD ps aux | grep '[c]rond' || exit 1

ENTRYPOINT ["/srv/dyndns/entrypoint.sh"]
CMD ["/srv/dyndns/cmd.sh"]
FROM alpine:latest

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
    tang && \
    apk upgrade --no-cache && \
    apk del apk-tools busybox curl && \
    rm -rf /var/cache/apk/* && \
    addgroup -S -g 1000 tanggroup && \
    adduser -S -u 1000 -G tanggroup tanguser

COPY tangd-entrypoint /usr/bin/

RUN mkdir -p /var/db/tang && \
    chmod +x /usr/bin/tangd-entrypoint && \
    chmod 755 /var/db/tang

USER tanguser

VOLUME ["/var/db/tang"]
EXPOSE 8080

CMD ["/usr/bin/tangd-entrypoint"]
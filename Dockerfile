FROM alpine:edge

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
    tang \
    socat && \
    addgroup -S tanggroup && \
    adduser -S tanguser -G tanggroup

COPY tangd-entrypoint /usr/bin/

RUN mkdir -p /var/db/tang && \
    chmod +x /usr/bin/tangd-entrypoint && \
    chown -R tanguser:tanggroup /usr/bin/tangd-entrypoint /var/db/tang

USER tanguser

VOLUME ["/var/db/tang"]
EXPOSE 8080

CMD ["/usr/bin/tangd-entrypoint"]
FROM alpine:edge

ENV SUMMARY="Network Presence Binding Daemon." \
    DESCRIPTION="Tang is a small daemon for binding data to the presence of a third party. This is a containerized Tang server." \
    VERSION=1 \
    TANG_LISTEN_PORT=80

LABEL name="stackhpc/tang" \
      summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
      version="${VERSION}" \
      usage="docker run -d -p 8080:80 -v tang-keys:/var/db/tang --name tang tang"

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
    tang \
    socat

COPY root /usr/bin/

VOLUME ["/var/db/tang"]
EXPOSE "${TANG_LISTEN_PORT}"

CMD ["/usr/bin/tangd-entrypoint"]

FROM alpine:3.20

RUN apk add --no-cache \
    android-tools \
    tini \
    && rm -rf /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

LABEL org.opencontainers.image.title="fire-tv-auto-launcher" \
      org.opencontainers.image.description="Auto-launches Wolf Launcher on Fire TV Stick via ADB" \
      org.opencontainers.image.source="https://github.com/ksmarty/fire-tx-auto-launcher"

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/entrypoint.sh"]

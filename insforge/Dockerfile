# InsForge backend and dashboard, official image, pinned by version and digest.
FROM ghcr.io/insforge/insforge-oss:v2.3.5@sha256:261242c80e03ba3157560c0ab71fc0ee10ef07500e3fa5c240626384f3f84042

COPY --chmod=755 start.sh /usr/local/bin/insforge-railway-start

ENV PORT=7130 \
    INSFORGE_DEPLOYMENT_METHOD=railway

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/insforge-railway-start"]

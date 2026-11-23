# PostgREST, the REST layer InsForge proxies database requests to.
# Same version as InsForge v2.3.5's docker-compose, pinned by digest.
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2

# Listen on all IPv4 and IPv6 addresses (Railway's private network uses IPv6).
ENV PGRST_SERVER_HOST="::" \
    PGRST_SERVER_PORT=3000 \
    PGRST_DB_SCHEMA=public \
    PGRST_DB_ANON_ROLE=anon \
    PGRST_DB_POOL=20 \
    PGRST_DB_CHANNEL_ENABLED=true \
    PGRST_OPENAPI_SERVER_PROXY_URI=http://localhost:3000 \
    PGRST_ADMIN_SERVER_PORT=3001

CMD ["postgrest"]

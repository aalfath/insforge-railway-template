# InsForge's own Postgres 15 build (pg_cron, http, pgcrypto, insforge_pg_utils),
# the image upstream's docker-compose uses. Pinned by version and digest.
FROM ghcr.io/insforge/postgres:v15.13.4@sha256:23b767e82e17da08cec1dc0c1214e3002a06154e73a2cb4dfad30ab540405698

# Config and first-boot SQL from InsForge v2.3.5 (deploy/docker-init/db).
COPY postgresql.conf /etc/postgresql/postgresql.conf
COPY db-init.sql /docker-entrypoint-initdb.d/01-init.sql
COPY jwt.sql /docker-entrypoint-initdb.d/02-jwt.sql
COPY --chmod=755 start.sh /usr/local/bin/insforge-postgres-start

# Railway mounts the volume at /var/lib/postgresql/data, which holds lost+found,
# so the cluster lives in a subfolder.
ENV PGDATA=/var/lib/postgresql/data/pgdata \
    POSTGRES_USER=postgres \
    POSTGRES_DB=insforge \
    JWT_EXP=3600

ENTRYPOINT ["/usr/local/bin/insforge-postgres-start"]

#!/bin/sh
# Start InsForge's Postgres with the encryption key the schedules schema needs
# (app.encryption_key) and memory settings that fit a 0.5 GB Railway service.
set -eu
: "${POSTGRES_PASSWORD:?POSTGRES_PASSWORD must be set}"
: "${ENCRYPTION_KEY:?ENCRYPTION_KEY must be set}"
export PGDATA="${PGDATA:-/var/lib/postgresql/data/pgdata}"

# A first deploy that was stopped during initdb leaves a data folder without
# PG_VERSION; the image's entrypoint would then skip init and fail. Start clean.
if [ -d "$PGDATA" ] && [ ! -s "$PGDATA/PG_VERSION" ]; then
  echo "Removing half-initialised data folder $PGDATA"
  rm -r "$PGDATA"
fi

exec docker-entrypoint.sh postgres \
  -c config_file=/etc/postgresql/postgresql.conf \
  -c cron.database_name="${POSTGRES_DB:-insforge}" \
  -c app.encryption_key="$ENCRYPTION_KEY" \
  -c shared_buffers="${PG_SHARED_BUFFERS:-96MB}" \
  -c max_connections="${PG_MAX_CONNECTIONS:-100}"

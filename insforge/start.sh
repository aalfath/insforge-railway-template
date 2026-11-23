#!/bin/sh
# Railway wrapper for the InsForge image: keep all state on the /insforge-data
# volume, wait for Postgres, run migrations, then start the server as `node`.
# Any failure exits non-zero, so Railway's ON_FAILURE policy restarts it.
set -eu

DATA_DIR="${INSFORGE_DATA_DIR:-/insforge-data}"
# The image sets STORAGE_DIR=/insforge-storage and LOGS_DIR=/insforge-logs, which
# are not on the volume: uploads there vanish on every redeploy. Always use the volume.
export STORAGE_DIR="$DATA_DIR/storage"
export LOGS_DIR="$DATA_DIR/logs"
export ROOT_ADMIN_USERNAME="${ROOT_ADMIN_USERNAME:-admin}"
export PORT="${PORT:-7130}"
# Keep the heap inside a 0.5 GB service unless the deployer overrides it.
export NODE_OPTIONS="${NODE_OPTIONS:---max-old-space-size=320}"
# Fewer upstream sockets to PostgREST than the default 50, to match its pool.
export POSTGREST_MAX_SOCKETS="${POSTGREST_MAX_SOCKETS:-20}"

: "${ROOT_ADMIN_PASSWORD:?ROOT_ADMIN_PASSWORD must be set}"
: "${JWT_SECRET:?JWT_SECRET must be set}"
: "${DATABASE_URL:?DATABASE_URL must be set}"

mkdir -p "$STORAGE_DIR" "$LOGS_DIR"
if [ "$(id -u)" = 0 ]; then
  # Railway volumes mount as root; hand anything not yet owned to the app user.
  find "$DATA_DIR" ! -user node -exec chown node:node {} +
fi

# Wait up to 3 minutes for Postgres (it may still be running its first initdb).
i=0
until pg_isready -q -h "${POSTGRES_HOST:-postgres}" -p "${POSTGRES_PORT:-5432}" -U "${POSTGRES_USER:-postgres}" -d "${POSTGRES_DB:-insforge}"; do
  i=$((i + 1))
  if [ "$i" -ge 90 ]; then
    echo "Postgres at ${POSTGRES_HOST:-postgres}:${POSTGRES_PORT:-5432} did not answer in 3 minutes" >&2
    exit 1
  fi
  sleep 2
done

cd /app/backend
# node-pg-migrate takes an advisory lock, so overlapping deploys wait for each other.
exec /usr/local/bin/insforge-entrypoint sh -c 'npm run --silent migrate:up && exec node ../dist/server.js'

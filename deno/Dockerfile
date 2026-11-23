# InsForge's edge-function runtime: Deno running functions/server.ts from
# InsForge v2.3.5 (copied into ./functions). Same Deno version upstream pins.
FROM denoland/deno:alpine-2.0.6@sha256:b64881926dcb3ba183b8767a4542aac69343dbc97008c22a60208cf07e4a21cc

WORKDIR /app
ENV DENO_DIR=/deno-dir \
    DENO_ENV=production \
    PORT=7133 \
    WORKER_TIMEOUT_MS=60000

COPY functions /app/functions
# Download the runtime's own imports at build time, so a restart doesn't
# depend on deno.land being reachable.
RUN mkdir -p /deno-dir && deno cache --no-lock functions/server.ts \
 && chown -R deno:deno /deno-dir

USER deno
CMD ["deno", "run", "--no-lock", "--unstable-worker-options", "--allow-net", "--allow-env", "--allow-read=./functions/worker-template.js", "functions/server.ts"]

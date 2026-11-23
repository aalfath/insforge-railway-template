# Changelog

## 2026-11-23: InsForge v2.3.5 (first release)

- InsForge `v2.3.5` (`ghcr.io/insforge/insforge-oss@sha256:261242c8…`), InsForge Postgres `v15.13.4`, PostgREST `v12.2.12`, Deno `2.0.6`, matching upstream's `docker-compose.prod.yml` for v2.3.5.
- Generated database password, JWT secret, encryption key and admin password per deploy.
- Postgres data and InsForge uploads/logs on volumes (the image's default storage path is not on the volume, so the start script moves it).
- Deno runtime pre-caches its imports and the function SDK at build time.
- Sized to run every service at 0.5 GB RAM / 1 vCPU.

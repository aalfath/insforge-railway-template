[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/insforge-1?utm_medium=integration&utm_source=button&utm_campaign=insforge)

# InsForge on Railway

InsForge is an open-source backend platform built for agentic coding. It gives you a Postgres database with a REST API, user auth, file storage, edge functions and an AI model gateway, and it exposes all of it to coding agents (Cursor, Claude Code, Codex and others) through its MCP server, so an agent can build and run the backend for your app.

## About Hosting InsForge

InsForge is four services that must find each other and share three secrets. This template runs InsForge v2.3.5 (the backend API and admin dashboard) behind a public Railway domain, InsForge's own Postgres 15 build with the extensions its auth and row-level security need, PostgREST for the database REST layer, and a Deno runtime for edge functions. They talk over Railway's private network. The database password, JWT secret, encryption key and admin password are generated for each deploy. Postgres data and uploaded files live on volumes, so they survive redeploys and restarts. Every service builds from a public GitHub repo pinned by version and digest.

## Common Use Cases

* Give a coding agent a real backend it can operate over MCP: create tables, set up auth, upload files and deploy functions
* Self-host the backend of a web or mobile app (database, auth, storage, functions) on infrastructure you control
* Run a private, per-project backend for prototypes and internal tools, then delete it when you are done

## Dependencies for InsForge Hosting

* PostgreSQL 15 with InsForge's extensions (included: `Postgres` service, InsForge's official image)
* PostgREST 12 and a Deno 2 runtime (included)

### Deployment Dependencies

* [InsForge on GitHub](https://github.com/InsForge/InsForge) and its [v2.3.5 release](https://github.com/InsForge/InsForge/releases/tag/v2.3.5)
* [InsForge documentation](https://docs.insforge.dev)
* [Template repository](https://github.com/aalfath/insforge-railway-template) (Dockerfiles, start scripts, changelog)

### Implementation Details

**Services**

* `InsForge`: backend API and admin dashboard on the public domain (health check `/api/health`). Uploaded files and logs are kept on its volume at `/insforge-data`.
* `Postgres`: InsForge's Postgres 15 image (pg_cron, http, pgcrypto, insforge_pg_utils), data on a volume. Holds the generated `POSTGRES_PASSWORD`, `JWT_SECRET` and `ENCRYPTION_KEY` that the other services reference.
* `PostgREST`: turns your tables into a REST API that InsForge proxies (private only).
* `Deno`: runs your edge functions (private only; InsForge serves them at `/functions/<slug>`).

**After deploy**

1. Open the `InsForge` service's domain and sign in as `admin` with the `ROOT_ADMIN_PASSWORD` variable from the `InsForge` service (generated for your deploy). There is no open sign-up for the dashboard.
2. In the dashboard, open **Connect** to copy your project API key (`ik_...`) and the MCP setup for your agent. A typical MCP client config is:

```json
{
  "mcpServers": {
    "insforge": {
      "command": "npx",
      "args": ["-y", "@insforge/mcp@latest"],
      "env": { "API_KEY": "ik_YOUR-KEY", "API_BASE_URL": "https://YOUR-DOMAIN" }
    }
  }
}
```

3. Optional: add an OpenRouter key under **AI** (or as `OPENROUTER_API_KEY` on `InsForge`) to use the AI gateway, OAuth client IDs for social sign-in, or `S3_*` variables to move file storage to S3-compatible storage. None are needed to start.

**Resources:** every service runs within 0.5 GB RAM and 1 vCPU, so the stack fits Railway's small plans; give `Postgres` and `InsForge` more for heavy use.

**Not included:** InsForge's Docker compute provider (it needs the host's Docker socket, which Railway does not provide) and the Vector log shipper from upstream's dev compose file.

**Updates:** when the template repo moves to a new InsForge release, Railway shows an update notice on your project; read `CHANGELOG.md` in the repo before you apply it. Migrations run automatically when `InsForge` starts.

## Why Deploy InsForge on Railway?

<!-- Recommended: Keep this section as shown below -->
Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying InsForge on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
<!-- End recommended section -->

## This repository

| Folder | Service | Base image (pinned) |
|---|---|---|
| `insforge/` | InsForge backend + dashboard | `ghcr.io/insforge/insforge-oss:v2.3.5@sha256:261242c8…` |
| `postgres/` | Postgres 15 with InsForge's extensions | `ghcr.io/insforge/postgres:v15.13.4@sha256:23b767e8…` |
| `postgrest/` | PostgREST | `postgrest/postgrest:v12.2.12@sha256:5f4ce744…` |
| `deno/` | Deno edge-function runtime (InsForge v2.3.5 `functions/`) | `denoland/deno:alpine-2.0.6@sha256:b6488192…` |

Each Railway service builds from its folder (root directory) on `main`.

### Variables

| Service | Variable | Value |
|---|---|---|
| Postgres | `POSTGRES_PASSWORD`, `JWT_SECRET`, `ENCRYPTION_KEY` | generated per deploy |
| InsForge | `ROOT_ADMIN_USERNAME` | `admin` |
| InsForge | `ROOT_ADMIN_PASSWORD` | generated per deploy; your dashboard login |
| all | connection settings | Railway references to the `Postgres`, `PostgREST` and `Deno` services |

No variable asks you for input. Do not change `JWT_SECRET` or `ENCRYPTION_KEY` after the first deploy: stored secrets and sessions depend on them.

### Updates

A merge to `main` here makes Railway offer an update to everyone who deployed the template. Read [CHANGELOG.md](CHANGELOG.md) before you apply one; breaking changes are listed first.

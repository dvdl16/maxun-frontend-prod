# maxun-frontend-prod

Production Docker image for the [Maxun](https://github.com/getmaxun/maxun) frontend.

The upstream Maxun project runs its frontend using the **Vite dev server**, which is memory-intensive and unsuitable for low-RAM hosts. This repo builds the frontend as a **static bundle** and serves it with **nginx**.

## Hosted image

```
ghcr.io/dvdl16/maxun-frontend-prod:<version>
ghcr.io/dvdl16/maxun-frontend-prod:latest
```

Images are hosted on the **GitHub Container Registry (ghcr.io)** and built automatically via GitHub Actions.

## Versioning

`version.txt` contains the Maxun upstream **image** version this image is built from (e.g. `0.0.35`). The Docker image is tagged with the same version.

To upgrade to a new Maxun release:
1. Update `version.txt` to the new version
2. Push to `main` — the GitHub Action will build and push a new image automatically

## How to use

Replace the `frontend` service in your `docker-compose.yml`:

```yaml
frontend:
  image: ghcr.io/dvdl16/maxun-frontend-prod:0.0.35
  container_name: maxun-frontend
  mem_limit: 64M
  restart: unless-stopped
  ports:
    - "5173:80"
  networks:
    - maxun-internal
    - blackkite-proxy-network
```


## Build args (baked in at build time)

| Build arg | Description |
|-----------|-------------|
| `VITE_BACKEND_URL` | Public URL of the Maxun backend API (e.g. `https://maxun-api.example.com`) |
| `VITE_PUBLIC_URL` | Public URL of the frontend (e.g. `https://maxun.mydomain.com`) |

These are stored as **GitHub Actions secrets** (`VITE_BACKEND_URL`, `VITE_PUBLIC_URL`) and injected during the CI build. They are **not** runtime environment variables.

## Building manually

```bash
docker build \
  --build-arg MAXUN_VERSION=0.0.35 \
  --build-arg VITE_BACKEND_URL=https://your-backend-url \
  --build-arg VITE_PUBLIC_URL=https://your-frontend-url \
  -t ghcr.io/dvdl16/maxun-frontend-prod:0.0.35 .
```

## GitHub Actions secrets required

Set these in your repository **Settings → Secrets and variables → Actions**:

| Secret | Example value |
|--------|---------------|
| `VITE_BACKEND_URL` | `https://maxun.mydomain.com` |
| `VITE_PUBLIC_URL` | `https://maxun.mydomain.com` |

ARG MAXUN_VERSION=0.0.35

# ── Stage 1: Build ────────────────────────────────────────────────────────────
FROM node:18-alpine AS builder

ARG MAXUN_VERSION
ARG VITE_BACKEND_URL
ARG VITE_PUBLIC_URL

ENV VITE_BACKEND_URL=$VITE_BACKEND_URL
ENV VITE_PUBLIC_URL=$VITE_PUBLIC_URL

RUN apk add --no-cache git

WORKDIR /app

# Clone the exact upstream release tag
RUN git clone --depth 1 --branch v${MAXUN_VERSION} \
    https://github.com/getmaxun/maxun.git .

RUN npm install --legacy-peer-deps

RUN npm run build

# ── Stage 2: Serve ────────────────────────────────────────────────────────────
FROM nginx:alpine

ARG MAXUN_VERSION

COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

LABEL org.opencontainers.image.source="https://github.com/dvdl16/maxun-frontend-prod"
LABEL org.opencontainers.image.description="Production nginx build of the Maxun frontend"
LABEL maxun.version="${MAXUN_VERSION}"

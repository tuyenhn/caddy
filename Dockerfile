FROM dhi.io/golang:1.25-debian13-dev AS builder

RUN CGO_ENABLED=0 go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

WORKDIR /build
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM dhi.io/caddy:2.11.2-debian13
COPY --from=builder /build/caddy /usr/local/bin/caddy


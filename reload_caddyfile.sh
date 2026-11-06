#!/usr/bin/env bash
# Format, validate, then reload the Caddy config inside the running container.
# If validation fails, the running config is left untouched.
set -euo pipefail

cd "$(dirname "$0")"

in_caddy() { docker compose exec -T caddy caddy "$@"; }

echo "==> Formatting"
for f in Caddyfile sites.caddy; do
  in_caddy fmt --overwrite "/etc/caddy/$f"
done

echo "==> Validating"
if ! in_caddy validate --config /etc/caddy/Caddyfile; then
  echo "Validation failed; not reloading." >&2
  exit 1
fi

echo "==> Reloading"
in_caddy reload --config /etc/caddy/Caddyfile
echo "Reloaded."

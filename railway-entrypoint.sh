#!/bin/sh
# Cut for Railway: validate the variables, then serve on $PORT on every interface.
set -eu

fail() { echo "railway-entrypoint: $*" >&2; exit 1; }

P="${ADMIN_PASSWORD:-}"; [ "${#P}" -ge 12 ] || fail "ADMIN_PASSWORD is required (12 characters or more)"
[ -n "${REDIS_URL:-}" ] || fail "REDIS_URL is required (redis://default:PASSWORD@HOST:6379)"

export PORT="${PORT:-8080}"
# "::" accepts IPv4 and IPv6, so the edge proxy and the private network (IPv6 only) both reach the server
export HOSTNAME="::"

echo "railway-entrypoint: port=$PORT redis_host=$(printf '%s' "$REDIS_URL" | sed -n 's|.*@\([^:/]*\).*|\1|p') uid=$(id -u)"
exec "$@"

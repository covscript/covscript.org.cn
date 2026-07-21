#!/usr/bin/env bash
# Runs inside the watchdog Docker service — health-checks sibling
# containers and restarts them via the Docker socket when they become
# unresponsive.
#
# Expects these environment variables (set in docker-compose.yml):
#   SANDBOX_CONTAINER   container name to restart (default covscript-sandbox)
#   WEB_CONTAINER       container name to restart (default covscript-web)
#   INTERVAL_SEC        seconds between checks (default 30)
#   MAX_FAILURES        consecutive failures before restart (default 3)
#   CURL_TIMEOUT        HTTP timeout per check in seconds (default 10)
#
# Pass --once to perform one health-check cycle and exit.  This is used by the
# systemd timer when the watchdog runs on the host.

set -eu

SANDBOX_URL="${SANDBOX_URL:-http://sandbox:8088}"
WEB_HEALTH_URL="${WEB_HEALTH_URL:-http://web:8080/healthz}"
INTERVAL="${INTERVAL_SEC:-30}"
MAX_FAILURES="${MAX_FAILURES:-3}"
CURL_TIMEOUT="${CURL_TIMEOUT:-10}"
SANDBOX_CONTAINER="${SANDBOX_CONTAINER:-covscript-sandbox}"
WEB_CONTAINER="${WEB_CONTAINER:-covscript-web}"
ONCE=false

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

usage() {
    echo "Usage: $0 [--once]" >&2
}

require_positive_integer() {
    local name="$1"
    local value="$2"
    if ! [[ "$value" =~ ^[1-9][0-9]*$ ]]; then
        log "ERROR: $name must be a positive integer, got '$value'"
        exit 2
    fi
}

for argument in "$@"; do
    case "$argument" in
        --once) ONCE=true ;;
        --help|-h) usage; exit 0 ;;
        *) usage; exit 2 ;;
    esac
done

require_positive_integer INTERVAL_SEC "$INTERVAL"
require_positive_integer MAX_FAILURES "$MAX_FAILURES"
require_positive_integer CURL_TIMEOUT "$CURL_TIMEOUT"

# Returns 0 if the endpoint responds with HTTP 200.
health_check() {
    local url="$1"
    local code
    code=$(curl -fsS -m "$CURL_TIMEOUT" -o /dev/null -w '%{http_code}' "$url" 2>/dev/null)
    [ "$code" = "200" ]
}

# Restart a container via the Docker socket.
restart_container() {
    local name="$1"
    if [ -z "$name" ]; then
        log "ERROR: container name not set for $2"
        return 1
    fi
    log "restarting container $name …"
    if docker restart "$name" >/dev/null 2>&1; then
        log "container $name restarted"
        return 0
    else
        log "ERROR: failed to restart $name"
        return 1
    fi
}

sandbox_failures=0
web_failures=0

log "watchdog started — interval=${INTERVAL}s  max_failures=${MAX_FAILURES}"
log "sandbox=${SANDBOX_URL}/api/stats  web=${WEB_HEALTH_URL}"

while true; do
    # --- sandbox ---
    if health_check "$SANDBOX_URL/api/stats"; then
        [ "$sandbox_failures" -gt 0 ] && log "sandbox recovered"
        sandbox_failures=0
    else
        sandbox_failures=$((sandbox_failures + 1))
        log "sandbox FAILED ($sandbox_failures/$MAX_FAILURES)"
        if [ "$sandbox_failures" -ge "$MAX_FAILURES" ]; then
            restart_container "$SANDBOX_CONTAINER" sandbox && sandbox_failures=0
        fi
    fi

    # --- web ---
    if health_check "$WEB_HEALTH_URL"; then
        [ "$web_failures" -gt 0 ] && log "web recovered"
        web_failures=0
    else
        web_failures=$((web_failures + 1))
        log "web FAILED ($web_failures/$MAX_FAILURES)"
        if [ "$web_failures" -ge "$MAX_FAILURES" ]; then
            restart_container "$WEB_CONTAINER" web && web_failures=0
        fi
    fi

    if "$ONCE"; then
        break
    fi

    sleep "$INTERVAL"
done

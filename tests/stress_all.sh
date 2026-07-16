#!/usr/bin/env bash
# Stress scenarios for web (8080) and sandbox (8088).
# Takes ~1.5 min. Run after (not during) test_sandbox.sh — the /api/run burst
# deliberately exhausts the per-IP rate limit for one 60s window.
#
# Usage: ./tests/stress_all.sh
set -u
cd "$(dirname "$0")"

WEB="${WEB_URL:-http://127.0.0.1:8080}"
SBX="${SANDBOX_URL:-http://127.0.0.1:8088}"
FAIL=0
run() { "$@" || FAIL=1; }

echo "########## 1. web: homepage, 16 workers x 15s ##########"
run ./stress.py "$WEB/" -c 16 -d 15 --label "web homepage"

echo "########## 2. web: static asset, 8 workers x 10s ##########"
asset=$(curl -s "$WEB/" | grep -oE 'assets/[A-Za-z0-9._-]+\.css' | head -1)
if [ -n "$asset" ]; then
    run ./stress.py "$WEB/$asset" -c 8 -d 10 --label "web css asset"
else
    echo "  (no css asset found, skipping)"
fi

echo "########## 3. sandbox direct: /api/stats, 16 workers x 10s ##########"
run ./stress.py "$SBX/api/stats" -c 16 -d 10 --label "sandbox stats (direct)"

echo "########## 4. web proxy: /api/stats, 16 workers x 10s ##########"
run ./stress.py "$WEB/api/stats" -c 16 -d 10 --label "sandbox stats (proxied)"

echo "########## 5. mixed load: homepage + proxied stats simultaneously ##########"
./stress.py "$WEB/" -c 8 -d 10 --label "mixed: homepage" &
MIX1=$!
./stress.py "$WEB/api/stats" -c 8 -d 10 --label "mixed: proxied stats" &
MIX2=$!
wait $MIX1 || FAIL=1
wait $MIX2 || FAIL=1

echo "########## 6. sandbox burst: 50 one-shot POSTs to /api/run ##########"
echo "# expect: <=10x200, rest 429, zero 5xx/conn errors (rate limiter under load)"
run ./stress.py "$SBX/api/run" -c 50 -n 50 --post 'system.out.println(1)' \
    --label "sandbox run burst (rate limited)"

echo "########## post-check: both servers still healthy ##########"
w=$(curl -s -m 5 -o /dev/null -w '%{http_code}' "$WEB/")
s=$(curl -s -m 5 -o /dev/null -w '%{http_code}' "$SBX/api/stats")
echo "web=$w sandbox=$s"
[ "$w" = 200 ] && [ "$s" = 200 ] || FAIL=1

if [ "$FAIL" = 0 ]; then echo "=== STRESS: ALL OK ==="; else echo "=== STRESS: FAILURES ==="; fi
exit $FAIL

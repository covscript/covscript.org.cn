#!/usr/bin/env bash
# Functional scenario tests for the web server (default: 127.0.0.1:8080).
#
# Covers static file serving, MIME types, 404 handling, keep-alive and the
# /api reverse proxy to the sandbox backend. The proxied /api/run calls
# consume the sandbox's per-IP rate-limit budget (2 runs).
#
# Usage:
#   ./tests/test_web.sh
#   WEB_URL=http://host:port ./tests/test_web.sh
set -u

BASE="${WEB_URL:-http://127.0.0.1:8080}"
PASS=0
FAIL=0

ok()   { PASS=$((PASS+1)); echo "  PASS: $1"; }
bad()  { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }
check(){ if [ "$1" = "$2" ]; then ok "$3 ($1)"; else bad "$3 (expected $2, got $1)"; fi; }

BODY_FILE=$(mktemp)
trap 'rm -f "$BODY_FILE"' EXIT

# probe <path> — sets HTTP_CODE, CONTENT_TYPE; body in $BODY_FILE
probe() {
    local out
    out=$(curl -s -m 10 -o "$BODY_FILE" -w '%{http_code} %{content_type}' "$BASE$1")
    HTTP_CODE="${out%% *}"
    CONTENT_TYPE="${out#* }"
}

echo "=== Web tests against $BASE ==="

echo "--- static pages ---"
probe /
check "$HTTP_CODE" 200 "GET /"
case "$CONTENT_TYPE" in text/html*) ok "index content-type ($CONTENT_TYPE)";; *) bad "index content-type ($CONTENT_TYPE)";; esac
grep -qi "<html" "$BODY_FILE" && ok "index looks like HTML" || bad "index body is not HTML"

probe /index.html
check "$HTTP_CODE" 200 "GET /index.html"

probe /favicon.ico
check "$HTTP_CODE" 200 "GET /favicon.ico"

echo "--- assets & MIME types ---"
# Pick one real asset of each type from the returned index.html
index_js=$(grep -oE 'assets/[A-Za-z0-9._-]+\.js' "$BODY_FILE" | head -1)
probe /
index_js=$(grep -oE 'assets/[A-Za-z0-9._-]+\.js' "$BODY_FILE" | head -1)
index_css=$(grep -oE 'assets/[A-Za-z0-9._-]+\.css' "$BODY_FILE" | head -1)
if [ -n "$index_js" ]; then
    probe "/$index_js"
    check "$HTTP_CODE" 200 "GET /$index_js"
    case "$CONTENT_TYPE" in *javascript*) ok "js content-type ($CONTENT_TYPE)";; *) bad "js content-type ($CONTENT_TYPE)";; esac
else
    bad "no .js asset referenced by index.html"
fi
if [ -n "$index_css" ]; then
    probe "/$index_css"
    check "$HTTP_CODE" 200 "GET /$index_css"
    case "$CONTENT_TYPE" in text/css*) ok "css content-type ($CONTENT_TYPE)";; *) bad "css content-type ($CONTENT_TYPE)";; esac
else
    bad "no .css asset referenced by index.html"
fi

font=$(ls wwwroot/fonts 2>/dev/null | head -1)
if [ -n "$font" ]; then
    probe "/fonts/$font"
    check "$HTTP_CODE" 200 "GET /fonts/$font"
fi

echo "--- error handling ---"
probe /no/such/page
check "$HTTP_CODE" 404 "missing page returns 404"
grep -qi "html" "$BODY_FILE" && ok "custom 404 page served" || bad "404 body empty"

probe /../etc/passwd
[ "$HTTP_CODE" != 200 ] && ok "path traversal blocked ($HTTP_CODE)" || { grep -q "root:" "$BODY_FILE" && bad "PATH TRAVERSAL LEAK" || ok "traversal returns page, not /etc/passwd"; }

echo "--- keep-alive ---"
# Two requests over one connection (one -o per URL)
codes=$(curl -s -m 10 -o /dev/null -o /dev/null -w '%{http_code} ' "$BASE/" "$BASE/favicon.ico")
check "$codes" "200 200 " "two requests on one keep-alive connection"

echo "--- /api reverse proxy to sandbox ---"
code=$(curl -s -m 10 -o "$BODY_FILE" -w '%{http_code}' "$BASE/api/stats")
check "$code" 200 "proxied /api/stats"
python3 -c "import json;json.load(open('$BODY_FILE'))" 2>/dev/null && ok "stats body is JSON" || bad "stats body not JSON"

code=$(curl -s -m 30 -o "$BODY_FILE" -w '%{http_code}' -X POST \
    --data-binary 'system.out.println("via proxy")' "$BASE/api/run")
check "$code" 200 "proxied /api/run"
grep -q "via proxy" "$BODY_FILE" && ok "proxied run output correct" || bad "proxied run output wrong: $(cat "$BODY_FILE")"

# 5s execution must survive the proxy (20s proxy timeout, sandbox timeout 5s)
code=$(curl -s -m 30 -o "$BODY_FILE" -w '%{http_code}' -X POST \
    --data-binary 'runtime.delay(20000)' "$BASE/api/run")
check "$code" 200 "proxied slow run survives proxy timeout"
python3 -c "import json;r=json.load(open('$BODY_FILE'));exit(0 if r['timed_out'] else 1)" \
    && ok "proxied timeout reported" || bad "proxied timeout not reported"

echo "=== $PASS passed, $FAIL failed ==="
[ "$FAIL" = 0 ]

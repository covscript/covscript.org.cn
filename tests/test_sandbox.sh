#!/usr/bin/env bash
# Functional scenario tests for the sandbox server (default: 127.0.0.1:8088).
#
# Rate-limit aware: /api/run allows 10 requests per IP per 60s window, so the
# suite is split into phases separated by 61s waits. Full run takes ~3 min.
#
# Usage:
#   ./tests/test_sandbox.sh            # full suite (functional + concurrency + rate limit)
#   ./tests/test_sandbox.sh --quick    # functional phase only (<=10 runs, no waits)
#   SANDBOX_URL=http://host:port ./tests/test_sandbox.sh
set -u

BASE="${SANDBOX_URL:-http://127.0.0.1:8088}"
API="$BASE/api/run"
QUICK=0
[ "${1:-}" = "--quick" ] && QUICK=1

PASS=0
FAIL=0

ok()   { PASS=$((PASS+1)); echo "  PASS: $1"; }
bad()  { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }
check(){ if [ "$1" = "$2" ]; then ok "$3 ($1)"; else bad "$3 (expected $2, got $1)"; fi; }

# jfield <file> <field> — extract a JSON field with python3
jfield() { python3 -c "import json,sys;print(json.load(open('$1'))['$2'])" 2>/dev/null; }

# run_code <code> — POST code, sets HTTP_CODE and leaves body in $BODY_FILE
BODY_FILE=$(mktemp)
trap 'rm -f "$BODY_FILE"' EXIT
run_code() {
    HTTP_CODE=$(curl -s -m 30 -o "$BODY_FILE" -w '%{http_code}' -X POST --data-binary "$1" "$API")
}

echo "=== Sandbox tests against $BASE ==="

# Allow a freshly started Compose service to finish opening its listener.
ready=0
for _ in $(seq 1 30); do
    if curl -fsS -m 1 "$BASE/api/stats" >/dev/null 2>&1; then
        ready=1
        break
    fi
    sleep 1
done
if [ "$ready" -ne 1 ]; then
    echo "Sandbox did not become ready at $BASE"
    exit 1
fi

# ---------------------------------------------------------------------------
echo "--- Phase 0: /api/stats ---"
code=$(curl -s -m 5 -o "$BODY_FILE" -w '%{http_code}' "$BASE/api/stats")
check "$code" 200 "stats returns 200"
total=$(jfield "$BODY_FILE" total)
[ -n "$total" ] && ok "stats has numeric total ($total)" || bad "stats missing total"

# ---------------------------------------------------------------------------
# Phase 1: functional — uses all 10 requests of the per-minute budget
echo "--- Phase 1: functional ---"

run_code 'system.out.println("Hello, CovScript!")'                       # run 1
check "$HTTP_CODE" 200 "hello world http"
check "$(jfield "$BODY_FILE" output)" 'Hello, CovScript!' "hello world output"
check "$(jfield "$BODY_FILE" exit_code)" 0 "hello world exit_code"

run_code 'var sum = 0
foreach i in range(1, 101) do sum += i
system.out.println(sum)'                                                 # run 2
check "$(jfield "$BODY_FILE" output)" '5050' "loop computation"

run_code 'throw runtime.exception("boom")'                               # run 3
check "$HTTP_CODE" 200 "runtime error http"
check "$(jfield "$BODY_FILE" exit_code)" 255 "runtime error exit_code"
grep -q "boom" "$BODY_FILE" && ok "error message in output" || bad "error message missing"

run_code ''                                                              # run 4 (counts!)
check "$HTTP_CODE" 400 "empty code rejected"

# Oversized body is rejected by the HTTP layer (max_body_size) before the
# handler runs, so it does NOT consume rate-limit budget.
python3 -c "print('# pad\n' * 12000)" | curl -s -m 10 -o "$BODY_FILE" -w '%{http_code}' \
    -X POST --data-binary @- "$API" > /tmp/oversize_code.txt
check "$(cat /tmp/oversize_code.txt)" 413 "oversized code rejected"

run_code 'try
    system.path.mkdir_p("/app/data/escape_probe")
    system.out.println(system.path.exist("/app/data/escape_probe"))
catch e
    system.out.println("blocked")
end
# Parent traversal from the bound /tmp must remain within the jail.
system.out.println(system.path.exist("/app/config.json"))
system.out.println(system.path.exist("/proc/self/status"))
system.out.println(system.path.exist("/tmp/../app/config.json"))'       # run 5
check "$(jfield "$BODY_FILE" output)" $'false\nfalse\nfalse\nfalse' "jail blocks host paths, traversal, and writes"

# The minimal jail exposes a rejecting /bin/sh stub, so system.run cannot
# execute a destructive shell command or any shell builtin.
run_code 'system.out.println(system.run("rm -rf *"))'                   # run 6
rm_result=$(jfield "$BODY_FILE" output)
if [ "$rm_result" != "0" ]; then ok "rm -rf command is rejected in jail ($rm_result)"; else bad "rm -rf command unexpectedly succeeded"; fi

run_code 'foreach i in range(100000) do system.out.println("line " + to_string(i))'  # run 7
outlen=$(python3 -c "import json;print(len(json.load(open('$BODY_FILE'))['output']))")
check "$outlen" 65536 "output truncated to 64KB"

run_code 'runtime.delay(20000)'                                          # run 8
check "$(jfield "$BODY_FILE" timed_out)" True "sleep hang -> timed_out"
check "$(jfield "$BODY_FILE" exit_code)" -9 "sleep hang -> SIGKILL"

run_code 'loop
    var x = 1
end'                                                                     # run 9
check "$(jfield "$BODY_FILE" timed_out)" True "cpu hang -> timed_out (ulimit -t / 137)"
# ulimit -t kills with SIGKILL; exit code 137 = 128+9 is now preserved
# for diagnostics instead of being normalized to -9.
check "$(jfield "$BODY_FILE" exit_code)" 137 "cpu hang -> 137 (ulimit SIGKILL)"

run_code 'var s = "xxxxxxxxxxxxxxxx"
loop
    s = s + s
end'                                                                     # run 10
grep -q "bad_alloc" "$BODY_FILE" && ok "memory bomb hits ulimit -v" || bad "memory bomb not contained: $(cat "$BODY_FILE")"

if [ "$QUICK" = 1 ]; then
    echo "=== quick mode: skipping concurrency + rate-limit phases ==="
    echo "=== $PASS passed, $FAIL failed ==="
    [ "$FAIL" = 0 ]; exit $?
fi

# ---------------------------------------------------------------------------
echo "--- waiting 61s for a fresh rate-limit window ---"
sleep 61

# Phase 2: concurrency — 4 parallel 2s tasks on 3 slots.
# All must succeed; wall clock ~4s (3 in parallel, 4th queued).
echo "--- Phase 2: concurrency slots ---"
t0=$(date +%s%N)
for i in 1 2 3 4; do                                                     # runs 1-4
    curl -s -m 30 -o /tmp/slot_$i.json -w '%{http_code}' -X POST \
        --data-binary 'runtime.delay(2000)
system.out.println("done")' "$API" > /tmp/slot_code_$i.txt &
done
wait
wall_ms=$(( ($(date +%s%N) - t0) / 1000000 ))
slot_ok=0
for i in 1 2 3 4; do
    [ "$(cat /tmp/slot_code_$i.txt)" = 200 ] && grep -q done /tmp/slot_$i.json && slot_ok=$((slot_ok+1))
done
check "$slot_ok" 4 "all 4 concurrent requests succeed"
if [ "$wall_ms" -lt 6000 ]; then ok "queueing works, wall=${wall_ms}ms (~4s expected)"; else bad "too slow: wall=${wall_ms}ms (executions serialized?)"; fi

# Phase 3: rate limit — same window already has 4 runs; fire 12 more quick
# ones: exactly 6 should pass (total 10), the rest must get 429.
echo "--- Phase 3: rate limit ---"
n200=0; n429=0; nother=0
for i in $(seq 1 12); do                                                 # runs 5-16
    code=$(curl -s -m 15 -o /dev/null -w '%{http_code}' -X POST --data-binary 'system.out.println(1)' "$API")
    case "$code" in
        200) n200=$((n200+1));;
        429) n429=$((n429+1));;
        *)   nother=$((nother+1));;
    esac
done
echo "  distribution: 200x$n200 429x$n429 otherx$nother"
check "$n200" 6 "exactly 6 of 12 pass (10/window total)"
check "$n429" 6 "remaining 6 rejected with 429"
check "$nother" 0 "no unexpected status codes"

echo "--- waiting 61s to verify window recovery ---"
sleep 61
run_code 'system.out.println("recovered")'
check "$HTTP_CODE" 200 "window expires -> requests accepted again"

# Server still healthy after everything
code=$(curl -s -m 5 -o /dev/null -w '%{http_code}' "$BASE/api/stats")
check "$code" 200 "server alive at end of suite"

echo "=== $PASS passed, $FAIL failed ==="
[ "$FAIL" = 0 ]

#!/usr/bin/env python3
"""Minimal HTTP stress driver (standard library only — no ab/wrk needed).

Examples:
    # 16 workers hammering the homepage for 15s
    ./tests/stress.py http://127.0.0.1:8080/ -c 16 -d 15

    # 50 concurrent one-shot POSTs to the sandbox (rate-limit burst test)
    ./tests/stress.py http://127.0.0.1:8088/api/run -c 50 -n 50 \
        --post 'system.out.println(1)'

Prints request count, RPS, status-code distribution, latency percentiles and
connection errors. Exit code 1 if any 5xx or connection error occurred
(unless --allow-errors).
"""
import argparse
import http.client
import sys
import threading
import time
import urllib.parse


def make_conn(parsed, timeout):
    return http.client.HTTPConnection(parsed.hostname, parsed.port or 80, timeout=timeout)


def worker(parsed, path, method, body, headers, deadline, counter, limit, results, errors, timeout):
    conn = make_conn(parsed, timeout)
    while True:
        if limit is not None:
            with counter["lock"]:
                if counter["n"] >= limit:
                    break
                counter["n"] += 1
        elif time.monotonic() >= deadline:
            break
        t0 = time.perf_counter()
        try:
            conn.request(method, path, body=body, headers=headers)
            resp = conn.getresponse()
            resp.read()
            results.append((resp.status, time.perf_counter() - t0))
            if resp.will_close:  # server closed (max_keep_alive reached etc.)
                conn.close()
                conn = make_conn(parsed, timeout)
        except Exception as e:
            errors.append(type(e).__name__)
            conn.close()
            conn = make_conn(parsed, timeout)
    conn.close()


def pct(sorted_lat, p):
    if not sorted_lat:
        return 0.0
    idx = min(len(sorted_lat) - 1, int(len(sorted_lat) * p / 100))
    return sorted_lat[idx]


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("url")
    ap.add_argument("-c", "--concurrency", type=int, default=8)
    ap.add_argument("-d", "--duration", type=float, default=10.0, help="seconds (ignored with -n)")
    ap.add_argument("-n", "--requests", type=int, default=None, help="total request cap (one-shot mode)")
    ap.add_argument("--post", default=None, help="POST this body instead of GET")
    ap.add_argument("--timeout", type=float, default=30.0)
    ap.add_argument("--allow-errors", action="store_true", help="don't fail on 5xx/conn errors")
    ap.add_argument("--label", default=None)
    args = ap.parse_args()

    parsed = urllib.parse.urlparse(args.url)
    path = parsed.path or "/"
    if parsed.query:
        path += "?" + parsed.query
    method = "POST" if args.post is not None else "GET"
    body = args.post.encode() if args.post is not None else None
    headers = {"Connection": "keep-alive"}
    if body is not None:
        headers["Content-Type"] = "text/plain"

    per_thread_results = [[] for _ in range(args.concurrency)]
    per_thread_errors = [[] for _ in range(args.concurrency)]
    counter = {"n": 0, "lock": threading.Lock()}
    deadline = time.monotonic() + args.duration

    t_start = time.perf_counter()
    threads = [
        threading.Thread(
            target=worker,
            args=(parsed, path, method, body, headers, deadline, counter,
                  args.requests, per_thread_results[i], per_thread_errors[i], args.timeout),
            daemon=True,
        )
        for i in range(args.concurrency)
    ]
    for t in threads:
        t.start()
    for t in threads:
        t.join()
    elapsed = time.perf_counter() - t_start

    results = [r for chunk in per_thread_results for r in chunk]
    errors = [e for chunk in per_thread_errors for e in chunk]
    lat = sorted(dt for _, dt in results)
    statuses = {}
    for st, _ in results:
        statuses[st] = statuses.get(st, 0) + 1

    label = args.label or f"{method} {args.url}"
    print(f"== {label} ==")
    print(f"  workers={args.concurrency} elapsed={elapsed:.1f}s requests={len(results)} rps={len(results)/elapsed:.1f}")
    print("  status:", " ".join(f"{k}x{v}" for k, v in sorted(statuses.items())) or "none")
    if lat:
        print(f"  latency ms: p50={pct(lat,50)*1000:.1f} p90={pct(lat,90)*1000:.1f} "
              f"p99={pct(lat,99)*1000:.1f} max={lat[-1]*1000:.1f}")
    if errors:
        dist = {}
        for e in errors:
            dist[e] = dist.get(e, 0) + 1
        print("  conn errors:", " ".join(f"{k}x{v}" for k, v in sorted(dist.items())))

    n5xx = sum(v for k, v in statuses.items() if k >= 500)
    if not args.allow_errors and (n5xx or errors):
        print(f"  RESULT: FAIL ({n5xx} 5xx, {len(errors)} conn errors)")
        sys.exit(1)
    print("  RESULT: OK")


if __name__ == "__main__":
    main()

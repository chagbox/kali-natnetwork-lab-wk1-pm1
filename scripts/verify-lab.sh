#!/usr/bin/env bash
# verify-lab.sh: run inside the Kali VM. Re-runs the lab checks and saves
# timestamped output to evidence/rerun-<timestamp>/
GW="10.0.0.1"
OUT="evidence/rerun-$(date +%Y%m%d-%H%M)"
mkdir -p "$OUT"

run() { # run <file> <command...>
  f="$1"; shift
  { echo "\$ $*"; "$@" 2>&1; echo "(captured $(date '+%d %b %Y %H:%M %Z'))"; } | tee "$OUT/$f"
  echo
}

run 01-ip-address.txt   ip -br addr
run 02-ip-route.txt     ip route
run 03-ping-gateway.txt ping -c 3 "$GW"
run 04-ping-internet.txt ping -c 3 8.8.8.8
run 05-ping-dns.txt     ping -c 20 google.com
run 06-https-check.txt  curl -sI https://www.kali.org

echo "Saved to $OUT"

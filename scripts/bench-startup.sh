#!/usr/bin/env bash
# Benchmark interactive nvim startup (dashboard, no file args) in a real TTY via tmux.
# Usage: scripts/bench-startup.sh [runs=10] [outdir=/private/tmp/opencode/nvim-perf] [file]
# With [file], opens that file instead of the dashboard.
set -euo pipefail
RUNS=${1:-10}
OUT=${2:-/private/tmp/opencode/nvim-perf}
FILE=${3:-}
PROBE="$(cd "$(dirname "$0")" && pwd)/bench-probe.lua"
mkdir -p "$OUT"
SESSION="nvimbench$$"
tmux new-session -d -s "$SESSION" -x 200 -y 50 "sleep 600"
tmux set-option -t "$SESSION" remain-on-exit on
trap 'tmux kill-session -t "$SESSION" 2>/dev/null || true' EXIT

: >"$OUT/results.txt"
for i in $(seq 1 "$RUNS"); do
  log="$OUT/startup-$i.log"
  res="$OUT/probe-$i.txt"
  rm -f "$log" "$res"
  tmux respawn-pane -k -t "$SESSION" \
    "NVIM_BENCH_OUT='$res' nvim --startuptime '$log' --cmd 'luafile $PROBE' $FILE"
  for _ in $(seq 1 400); do [[ -s "$res" ]] && break; sleep 0.05; done
  started=$(grep -- '--- NVIM STARTED ---' "$log" | tail -1 | awk '{print $1}')
  line="started=$started $(cat "$res")"
  echo "$line" | tee -a "$OUT/results.txt"
done

python3 - "$OUT/results.txt" <<'PY' | tee "$OUT/summary.txt"
import sys, statistics as st
cols = {}
for line in open(sys.argv[1]):
    for kv in line.split():
        k, v = kv.split("=")
        cols.setdefault(k, []).append(float(v))
for k in sorted(cols):
    s = sorted(cols[k])
    print(f"{k:9} min={s[0]:7.1f} median={st.median(s):7.1f} mean={st.mean(s):7.1f} max={s[-1]:7.1f}")
PY

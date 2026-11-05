#!/bin/bash
# Launches the app several times, alternating SF / Infomaniak Sans, and prints median results.
# Usage: scripts/run_bench.sh sim|device <UDID> [runs=6] [suite=micro|extended]
set -uo pipefail
cd "$(dirname "$0")/.."
TARGET=$1; ID=$2; RUNS=${3:-6}; SUITE=${4:-micro}
BUNDLE_ID=com.infomaniak.FontPerfTest
mkdir -p results; OUT=results/$TARGET-$SUITE.jsonl; : > "$OUT"
for i in $(seq 1 "$RUNS"); do
  for font in sf ims; do
    echo "run $i/$RUNS – $font" >&2
    if [ "$TARGET" = sim ]; then
      xcrun simctl launch --console-pty --terminate-running-process "$ID" $BUNDLE_ID -font $font -suite "$SUITE" 2>&1
    else
      xcrun devicectl device process launch --console --terminate-existing --device "$ID" $BUNDLE_ID -- -font $font -suite "$SUITE" 2>&1
    fi | grep '^RESULT' | sed 's/^RESULT //' >> "$OUT"
  done
done
/usr/bin/python3 scripts/summarize.py "$OUT"

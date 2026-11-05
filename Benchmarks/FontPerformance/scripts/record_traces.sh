#!/bin/bash
# Records one Time Profiler trace per font, then prints CPU time per phase (signposts).
# Usage: scripts/record_traces.sh sim|device <UDID> [suite=micro|extended] [seconds]
set -uo pipefail
cd "$(dirname "$0")/.."
TARGET=$1; ID=$2; SUITE=${3:-micro}
DEFAULT_SECONDS=40; [ "$SUITE" = extended ] && DEFAULT_SECONDS=130
SECONDS_LIMIT=${4:-$DEFAULT_SECONDS}
APP=com.infomaniak.FontPerfTest
mkdir -p traces
for font in sf ims; do
  NAME=traces/$TARGET-$SUITE-$font
  rm -rf "$NAME.trace"
  # xctrace sometimes hangs while saving: kill it after the time limit + 3 min.
  xcrun xctrace record --template 'Time Profiler' --device "$ID" --output "$NAME.trace" \
    --time-limit "${SECONDS_LIMIT}s" --launch -- "$APP" -font $font -suite "$SUITE" > "$NAME.log" 2>&1 &
  PID=$!
  ( for _ in $(seq $((SECONDS_LIMIT + 180))); do sleep 1; kill -0 $PID 2>/dev/null || exit 0; done; kill $PID ) &
  wait $PID
  if [ ! -d "$NAME.trace" ]; then echo "xctrace failed:"; cat "$NAME.log"; exit 1; fi
  tail -1 "$NAME.log"; rm -f "$NAME.log"
  for table in time-profile:tp os-signpost:sp; do
    xcrun xctrace export --input "$NAME.trace" \
      --xpath "/trace-toc/run[@number=\"1\"]/data/table[@schema=\"${table%%:*}\"]" > "$NAME-${table##*:}.xml"
  done
done
/usr/bin/python3 scripts/phases.py sf:traces/$TARGET-$SUITE-sf ims:traces/$TARGET-$SUITE-ims
rm -f traces/*.xml

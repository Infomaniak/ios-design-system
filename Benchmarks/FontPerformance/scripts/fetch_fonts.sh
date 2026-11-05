#!/bin/bash
# Downloads Infomaniak Sans from Infomaniak/design-system into the app resources.
set -euo pipefail
cd "$(dirname "$0")/.."
DEST=FontPerfTest/Resources/Fonts
BASE=https://raw.githubusercontent.com/Infomaniak/design-system/main/packages/assets/fonts/fonts/infomaniak-sans
mkdir -p "$DEST"
for style in normal italic; do
  curl -sSfL -o "$DEST/infomaniak-sans.variable.$style.ttf" "$BASE/infomaniak-sans.variable.$style.%5Bopsz%2Cwght%5D.ttf"
done
ls -l "$DEST"

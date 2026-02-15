#!/bin/sh
set -eu

DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
mkdir -p "$DIR"
TS="$(date +'%Y-%m-%d_%H-%M-%S')"
FILE="$DIR/$TS.png"

case "${1:-area}" in
  area)
    grim -g "$(slurp)" "$FILE"
    wl-copy < "$FILE"
    swappy -f "$FILE" >/dev/null 2>&1 &
    ;;
  full)
    grim "$FILE"
    wl-copy < "$FILE"
    ;;
  window)
    grim -g "$(slurp)" "$FILE"
    wl-copy < "$FILE"
    ;;
  *)
    echo "usage: $0 {area|full|window}" >&2
    exit 2
    ;;
esac

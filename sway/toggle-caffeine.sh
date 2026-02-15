#!/bin/sh

LOCK_FILE="/tmp/sway-caffeine-mode"
GUARD_DIR="/tmp/sway-caffeine-guard"
LOG="/tmp/sway-caffeine-toggle.log"

IDLE_TIMEOUT=300
SCREEN_OFF_TIMEOUT=600

LOCK_CMD='swaylock -f -c 08080a'
SCREEN_OFF_CMD='swaymsg "output * power off"'
RESUME_CMD='swaymsg "output * power on"'

log() {
  printf '%s %s\n' "$(date '+%F %T')" "$*" >> "$LOG"
}

if ! mkdir "$GUARD_DIR" 2>/dev/null; then
  log "busy (another toggle running), exiting"
  exit 0
fi
trap 'rmdir "$GUARD_DIR" 2>/dev/null' EXIT INT TERM

pkill -x swayidle 2>/dev/null || true

i=0
while pgrep -x swayidle >/dev/null 2>&1; do
  i=$((i+1))
  [ "$i" -gt 50 ] && break
  sleep 0.05
done

if [ -e "$LOCK_FILE" ]; then
  rm -f "$LOCK_FILE"
  log "toggle: OFF (removed $LOCK_FILE)"

  swayidle -w \
    timeout "$IDLE_TIMEOUT" "$LOCK_CMD" \
    timeout "$SCREEN_OFF_TIMEOUT" "$SCREEN_OFF_CMD" resume "$RESUME_CMD" \
    before-sleep "$LOCK_CMD" \
    >>"$LOG" 2>&1 &

else
  : > "$LOCK_FILE"
  log "toggle: ON (created $LOCK_FILE)"

  swayidle -w \
    before-sleep "$LOCK_CMD" \
    >>"$LOG" 2>&1 &
fi

pkill -SIGRTMIN+8 waybar 2>/dev/null || true
log "signaled waybar (SIGRTMIN+8)"


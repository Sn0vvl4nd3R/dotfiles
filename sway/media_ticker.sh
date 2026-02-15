#!/usr/bin/env bash
set -o pipefail

VIEW="${WAYBAR_MEDIA_VIEW:-30}"
DELAY="${WAYBAR_MEDIA_DELAY:-0.20}"
PAD="${WAYBAR_MEDIA_PAD:-"   ::   "}"
EMPTY="${WAYBAR_MEDIA_EMPTY:-"-- NO SIGNAL --"}"
PC_TIMEOUT="${WAYBAR_MEDIA_TIMEOUT:-1.0}"

status="Stopped"
meta=""
offset=0

STATUS_PID=""
META_PID=""
STATUS_FD=""
META_FD=""

have_timeout=0
command -v timeout >/dev/null 2>&1 && have_timeout=1

pc_oneshot() {
  if (( have_timeout )); then
    timeout "${PC_TIMEOUT}"s playerctl "$@" 2>/dev/null || true
  else
    playerctl "$@" 2>/dev/null || true
  fi
}

pid_alive() {
  local pid="${1:-}"
  [[ -z "$pid" ]] && return 1
  local st
  st="$(ps -o stat= -p "$pid" 2>/dev/null | tr -d '[:space:]' || true)"
  [[ -n "$st" && "$st" != Z* ]]
}

cleanup_follow() {
  [[ -n "$STATUS_PID" ]] && kill "$STATUS_PID" 2>/dev/null || true
  [[ -n "$META_PID"   ]] && kill "$META_PID"   2>/dev/null || true

  if [[ -n "$STATUS_FD" ]]; then eval "exec ${STATUS_FD}<&-"; STATUS_FD=""; fi
  if [[ -n "$META_FD"   ]]; then eval "exec ${META_FD}<&-";   META_FD="";   fi

  [[ -n "$STATUS_PID" ]] && wait "$STATUS_PID" 2>/dev/null || true
  [[ -n "$META_PID"   ]] && wait "$META_PID"   2>/dev/null || true

  STATUS_PID=""
  META_PID=""
}

trap 'cleanup_follow' EXIT
trap 'cleanup_follow; exit 0' INT TERM HUP PIPE

start_playerctld_if_possible() {
  command -v playerctld >/dev/null 2>&1 || return 0
  pgrep -x playerctld >/dev/null 2>&1 && return 0
  playerctld daemon >/dev/null 2>&1 & disown || true
}

start_follow() {
  cleanup_follow

  coproc STATUS_CP { playerctl -p playerctld --follow status --format '{{status}}' 2>/dev/null; }
  STATUS_FD="${STATUS_CP[0]}"
  STATUS_PID="${STATUS_CP_PID}"

  coproc META_CP { playerctl -p playerctld --follow metadata --format '{{default(artist,"")}} - {{default(title,"")}}' 2>/dev/null; }
  META_FD="${META_CP[0]}"
  META_PID="${META_CP_PID}"
}

drain_updates() {
  local line

  if [[ -n "$STATUS_FD" ]]; then
    while IFS= read -r -t 0.01 -u "$STATUS_FD" line; do
      status="$line"
      [[ "$status" != "Playing" ]] && offset=0
    done
  fi

  if [[ -n "$META_FD" ]]; then
    while IFS= read -r -t 0.01 -u "$META_FD" line; do
      meta="$line"
      offset=0
    done
  fi
}

render_no_signal() {
  printf '%s\n' "$EMPTY" || exit 0
}

render_static() {
  if [[ -z "${meta//[[:space:]]/}" ]]; then
    render_no_signal
    return
  fi

  if [[ "$status" == "Stopped" ]]; then
    render_no_signal
    return
  fi

  printf '%s\n' "$meta" || exit 0
}

render_scroll() {
  if [[ -z "${meta//[[:space:]]/}" ]]; then
    render_no_signal
    return
  fi

  local base="${meta}${PAD}"
  local long="${base}${base}${base}"
  local maxoff=${#base}
  (( maxoff > 0 )) || maxoff=1
  offset=$(( offset % maxoff ))

  printf '%.*s\n' "$VIEW" "${long:offset:VIEW}" || exit 0
  offset=$((offset + 1))
}

start_playerctld_if_possible

status="$(pc_oneshot -p playerctld status --format '{{status}}')"
meta="$(pc_oneshot -p playerctld metadata --format '{{default(artist,"")}} - {{default(title,"")}}')"
[[ -n "$status" ]] || status="Stopped"
render_static

start_follow

while :; do
  if ! pid_alive "$STATUS_PID" || ! pid_alive "$META_PID"; then
    start_playerctld_if_possible
    start_follow
    status="Stopped"
    meta=""
    offset=0
  fi

  drain_updates

  if [[ "$status" == "Playing" ]]; then
    render_scroll
    sleep "$DELAY"
  else
    render_static
    sleep 1
  fi
done


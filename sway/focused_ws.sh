#!/bin/sh

swaymsg -r -t get_workspaces | jq -r '.[] | select(.focused) | .name'

swaymsg -r -t subscribe -m '["workspace"]' | \
jq --unbuffered -r 'select(.change == "focus") | .current.name'

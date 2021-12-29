#!/bin/sh

window="$(xdotool search --class ${1:-scratchpad})"

if [ -n "$window" ]; then
	bspc node "$window" -g hidden -f
else
	bspc rule -a '*' -o state=floating sticky=on layer=above && st -c "${1-scratchpad}" -e ${1:-}
fi

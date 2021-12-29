#!/bin/sh

FOLDER="$HOME/Pictures/Screenshots"
NAME="$(date +%b%d_%H:%M:%S).png"
IMAGE="$FOLDER/$NAME"
INFO="Screenshot saved as:"

mkdir -p "$FOLDER"

copy_and_notify() {
	xclip -selection clipboard -t image/png -i "$IMAGE"
	printf 'TAG:snap\tCMD:%s\tIMG:%s\t%s\t%s\n' "sxiv $IMAGE" "$IMAGE" "$INFO" "$NAME" > "$XNOTIFY_FIFO"
}

case $1 in
	area)
		maim -u -m 1 -sB "$IMAGE" > /dev/null 2>&1 && copy_and_notify
	;;
	desktop)
		maim -u -m 1 "$IMAGE" && copy_and_notify
	;;
	window)
		if [[ -z $(xdotool getactivewindow) ]]; then
			printf 'Error:\tNo window avaliable' > $XNOTIFY_FIFO
		else
			maim -u -m 1 -Bi $(xdotool getactivewindow) "$IMAGE" && copy_and_notify
		fi
	;;
esac

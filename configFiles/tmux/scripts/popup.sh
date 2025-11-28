#!/bin/sh

if [ "$(tmux display-message -p -F "#{session_name}")" = "popup" ];then
	tmux detach-client
else
	tmux popup -E "(tmux attach -t popup:$1) || (tmux neww -t popup -n $1 $1 && tmux attach -t popup:$1) || (tmux new -s popup -n $1 $1)"
fi

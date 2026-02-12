#!/bin/sh

HEIGHT=${2:-50%}

if [ "$(tmux display-message -p -F "#{session_name}")" = "popup" ]; then
    tmux detach-client
else
    tmux popup -d "#{pane_current_path}" -h "$HEIGHT" -w 80% -E \
    "(tmux attach -t popup:$1) || (tmux neww -t popup -n $1 $1 && tmux attach -t popup:$1) || (tmux new -s popup -n $1 $1)"
fi

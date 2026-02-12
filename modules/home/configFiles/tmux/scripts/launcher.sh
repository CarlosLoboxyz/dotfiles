 #!/bin/sh

OPTS="$(tmuxp ls)"
LIST="$(awk '{print $1, NR, "\"run '\''tmuxp load -y", $1 "'\''\""}' <<< $OPTS)"
xargs tmux display-menu -T "Load session" <<< $LIST

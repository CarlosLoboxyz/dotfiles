#!/bin/sh

DIR="$(dirname "$0")"

awk -F ',' -v q="$1" '
    # 1. Process the "icons" file first (FNR == NR)
    # Map the icon_name (field 1) to the actual icon glyph (field 2)
    FNR == NR {
        icon_map[$1] = $2
        next
    }

    # 2. Process "icons-definitions" (FNR != NR)
    # Check if the file extension/name (field 1) matches our query
    $1 == q {
        # Look up the icon glyph using the icon_name (field 2)
        glyph = icon_map[$2]
        color = $3

        # Print the Tmux formatted string
        printf "#[fg=%s]%s ", color, glyph
        found = 1
        exit
    }

    # 3. If no match was found after reading everything, print default
    END {
        if (!found) printf " "
    }
' "$DIR/icons" "$DIR/icons-definitions"

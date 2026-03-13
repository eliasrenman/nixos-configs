#!/bin/bash

LOC="$1"
# HTML encode string as %20
TEMP=$(curl -s 'https://wttr.in/'${LOC}'?format=%t\n&m')
ICON=$(curl -s 'https://wttr.in/'${LOC}'?format=1' | grep -o '^\S*' )
# echo $ICON
echo '{"text": "'$TEMP'", "tooltip": "'$ICON' '$LOC'", "class": "weather" }'

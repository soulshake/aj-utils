#!/bin/bash

echo -n '$ '

TEXT="whois mush.xyz
how now brown cow
docker ps
"

IFS="
"
for line in $TEXT; do
    len=${#line}
    for i in $(seq 0 $len); do
        while read -n 1; do
            echo -n -e '\b' "${line:i:1}" 
        done
    done
    echo
    continue

    [ -z $CMD ] && CMD="$line"
    [ -z $SHOW ] && SHOW="$line"
    while true; do
        while read -n 1; do
            HEAD=$(echo "$SHOW" | awk ' {print $1}')
            TAIL=$(echo "$SHOW" | awk ' {$1=""; print $0}')

            # if it's the last word of the command, execute it
            # if [[ $HEAD == $TAIL ]]; then
            if [[ -z $TAIL ]]; then
                echo
                eval "$CMD"
                unset CMD
                unset HEAD
                unset TAIL
                unset SHOW
                echo -n "\$ "
            else
                echo -n -e '\b'
                echo -n "$HEAD "
                SHOW="$TAIL"
            fi
        done
    done
done

#!/bin/bash
# Credit: @jcsalterego on GitHub/Twitter

# If there is a first argument and expansions do not match
if [ -n "$1" ] && [ ! -f "$1" ] && [ "$(echo $1*)" != "$1*" ]; then
    echo "There are completions!: "$(echo $1*)
    exit 1
else
    $EDITOR $@
fi

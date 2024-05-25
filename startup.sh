#!/usr/bin/env bash

xsetroot -solid "#133733"

xhost si:localuser:root

# Fix Lenovo mouse issue where it emits keystrokes, breaking scrolling back in terminal output:
# (see `halp mouse` for more info)
xinput list \
    | grep 'Virtual core keyboard' -A99 \
    | grep 'Lenovo Lenovo Y Gaming Precision Mouse' \
    | grep -v 'Consumer Control' \
    | awk -F'[=\t]' '{ print $3 }' \
    | xargs -I{} xinput --disable {}

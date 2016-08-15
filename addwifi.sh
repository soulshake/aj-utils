#!/bin/bash

case "$1" in
show)
    shift
    if [ -z $1 ]; then
        nmcli connection show --active
    else
        nmcli connection show "$1"
    fi
    exit
    ;;
edit)
    shift
    echo "Editing down $1"
    nmtui edit
    ;;
down)
    shift
    echo "Putting down $1"
    if [ -z $1 ]; then
        nmcli connection show --active \
            | tail -n1 \
            | awk '{print $3}' \
            | xargs nmcli connection down
        exit $?
    fi
    ;;
help)
    echo $SSID $PSD
    echo "$0 [show|edit|down]"
    ;;
tui)
    nmtui
    ;;
*)
    # nmcli c up w-${SSID}
    SSID=$1
    PSK=$2
    if [ -z "$SSID" ]; then
        nmcli d wifi list
        exit 0
    fi

    if [ -n "$PSK" ]; then
        echo "Adding SSID $SSID with PSK $PSK..."
        nmcli dev wifi connect "$SSID" password "$PSK"
    fi

    if [ -z "$PSK" ]; then
        echo "Adding SSID $SSID with no key..."
        nmcli dev wifi connect "$SSID"
    fi
    ;;
esac


echo "done"

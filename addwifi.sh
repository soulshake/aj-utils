#!/bin/bash

if [[ $1 == "edit" ]]; then
    echo "shifting"
    shift
fi

if [ $1 == "show" ]; then
    if [ -z $2 ]; then
        nmcli connection show --active
    else
        nmcli connection show "$2"
    fi
    exit
fi

if [ $1 == "down" ]; then
    nmcli connection show --active \
        | tail -n1 \
        | awk '{print $3}' \
        | xargs nmcli connection down
    exit $?
fi

SSID=$1
PSK=$2

if [ -z "$SSID" ]; then
    nmcli d wifi list \
        | sort
    exit 0
fi

if [ "$SSID" == "tui" ]; then
    nmtui
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

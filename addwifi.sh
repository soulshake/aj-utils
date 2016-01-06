#!/bin/sh

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

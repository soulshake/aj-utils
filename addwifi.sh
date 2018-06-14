#!/bin/bash

activate_connection() {
  conn="$1"
}

case "$1" in
show)
  shift
  if [ -z "$1" ]; then
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
  if [ -z "$1" ]; then
    nmcli connection show --active |
      tail -n1 |
      awk '{print $3}' |
      xargs nmcli connection down
    exit $?
  fi
  ;;
help)
  echo "$SSID" "$PSD"
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

  if [ -e "/etc/NetworkManager/system-connections/$SSID" ]; then
    echo "Found existing network:"
    sudo egrep '^ssid=|^psk=' "/etc/NetworkManager/system-connections/$SSID"
    conn="$(nmcli conn | grep -i "${SSID}" | head -n1 | awk '{print $1}')"

    if [ -z "$PSK" ]; then
      echo "Activating conn ${conn} (SSID $SSID) with no key..."
      nmcli conn up "$conn"
    else
      echo "key was provided; adding new connection!"
    fi
  fi

  if [ -z "$PSK" ]; then
    echo "Adding SSID $SSID with no key..."
    nmcli dev wifi connect "$SSID"
  fi
  if [ -n "$PSK" ]; then
    echo "Adding SSID $SSID with PSK $PSK..."
    nmcli dev wifi connect "$SSID" password "$PSK"
  fi

  ;;
esac

echo "done"

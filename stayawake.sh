#!/bin/bash

sleeptime="$@"
[ -z $sleeptime ] && echo "Provide an argument for how long to sleep" && exit 1
echo "Staying awake for $sleeptime seconds."

(
  sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
  sleep "$@"
  sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
  echo "Re-enabled hibernation."
) &

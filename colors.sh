#!/bin/bash
#shellcheck disable=SC2016
# tputcolors

echo
echo -e "$(tput bold) reg  bld  und   tput-command-colors$(tput sgr0)"

for i in $(seq 1 7); do
    echo " $(tput setaf "${i}")Text$(tput sgr0) $(tput bold)$(tput setaf "${i}")Text$(tput sgr0) $(tput sgr 0 1)$(tput setaf "${i}")Text$(tput sgr0)  \$(tput setaf ${i})"
done

echo ' Bold            $(tput bold)'
echo ' Underline       $(tput sgr 0 1)'
echo ' Reset           $(tput sgr0)'
echo

curl -SsLf https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash

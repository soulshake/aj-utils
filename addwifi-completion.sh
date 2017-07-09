#!/usr/bin/env bash
# Complete wifi SSIDs for use with addwifi.sh

__complete_ssids() {
    COMPREPLY=( $(compgen -W "$(__ssids)" -- ${cur}) )
}

__ssids() {
    # Todo: split by "Infra"; SSID is everything preceding that word
    # maybe with:
    # IFS=" Infra " 
    nmcli d wifi list \
        | grep -v -e "^\* *SSID" \
        | tr -d '^*' \
        | awk '{print $1}' \
        | grep -v -- "--" \
        | sort -u
}

__complete_password_or_not() {
    ssid="$1"
    open=$(nmcli d wifi list \
        | grep "$ssid" \
        | grep -e "-- *$")
    if [[ ! "$open" == "" ]]; then
        echo -n " # No password needed"
    else
        echo -n "PASSWORD: $open"
    fi
}

__addwifi_previous_extglob_setting=$(shopt -p extglob)
shopt -s extglob

_addwifi.sh() {
    local previous_extglob_setting=$(shopt -p extglob)
    shopt -s extglob

    COMPREPLY=()
    local cur prev words cword
    _get_comp_words_by_ref -n : cur prev words cword
    case "$prev" in
        "addwifi.sh")
            __complete_ssids
            ;;
        *)
            __complete_password_or_not "$prev"
            ;;
    esac
}



eval "$__addwifi_previous_extglob_setting"
unset __addwifi_previous_extglob_setting

complete -F _addwifi.sh addwifi.sh

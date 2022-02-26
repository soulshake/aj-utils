#!/bin/bash

# By FX
# https://gist.github.com/bombela/51e04a40808e11b61a3f0b205322bb8a
# 2016-12-31

CALLER_SHELL="$(ps -o comm= $PPID)"
FILES=()
CMD=()

LOGFILE=
FIND=

FIND_IGNORE="-path '*/.*'"

function find_ignore() {
	[[ ${#@} -lt 1 ]] && return
	echo -n "-path '$1'"
	shift
	for glob in $@; do
		echo -n " -o -path '$glob'"
	done
}

function find_exts() {
	[[ ${#@} -lt 1 ]] && return
	echo -n "-name '*.$1'"
	shift
	for ext in $@; do
		echo -n " -o -name '*.$ext'"
	done
}

while [[ $# > 0 ]]; do
	[[ "$1" =~ -.* ]] || break
	opt=$1
	shift

	if [[ "$opt" == "--" ]]; then
		break
	fi

	if [[ "$opt" == "-l" ]]; then
		LOGFILE=$1
		shift
		continue
	fi

	if [[ "$opt" == "-go" ]]; then
		FIND="find . \( $(find_ignore '*/.*' ./go-build ./vendor) \) -prune -o -name '*.go' -print"
		continue
	fi

	if [[ "$opt" == "-rust" ]]; then
		FIND="find . \( $(find_ignore '*/.*' ./target) \) -prune -o -name '*.rs' -print"
		continue
	fi

	if [[ "$opt" == "-cxx" ]]; then
		FIND="find . \( $(find_ignore '*/.*' ./target) \) -prune -o \( $(find_exts c h cpp hpp cxx) \) -print"
		continue
	fi

	if [[ "$opt" == "-f" ]]; then
		FIND="find . \( $(find_ignore '*/.*') \) -prune -o -name '$1' -print"
		shift
		continue
	fi

	echo "Unknown option: $opt"
	exit 1
done

while [[ $# > 0 ]]; do
	CMD[${#CMD[@]}]=$1
	shift
done

if [[ -n "${FIND}" ]]; then
	echo "${FIND}"
	while read path; do
		FILES[${#FILES[@]}]="${path}"
	done < <(eval "${FIND}")
else
	while read path; do
		FILES[${#FILES[@]}]="${path}"
	done
fi

echo "files   : ${FILES[@]}"
echo "file cnt: ${#FILES[@]}"
echo "command : ${CMD[@]}"
[[ -n "${LOGFILE}" ]] && echo "logfile : ${LOGFILE}"

while true; do
	echo  -e "\x1b[35m-- $(date +'%F %T %N') --\x1b[0m"
	if [[ -n "${LOGFILE}" ]]; then
		$CALLER_SHELL -c "${CMD[*]}" 2>&1 | tee "${LOGFILE}"
	else
		$CALLER_SHELL -c "${CMD[*]}"
	fi
	inotifywait -e modify,move_self,delete_self ${FILES[@]} || break
done

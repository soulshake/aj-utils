#!/bin/bash
# https://stackoverflow.com/questions/192319/how-do-i-know-the-script-file-name-in-a-bash-script


logger
logger "# arguments called with ---->  ${@}     "
logger "# \$1 ----------------------->  $1       "
logger "# \$2 ----------------------->  $2       "
logger "# path to me --------------->  ${0}     "
logger "# parent path -------------->  ${0%/*}  "
logger "# my name ------------------>  ${0##*/} "
logger "# pwd ---------------------->  $(pwd)   "
#logger "# PWD ---------------------->  $PWD     "
logger "# BASH_SOURCE -------------->  $BASH_SOURCE"
#logger "# BASH_COMMAND ------------->  $BASH_COMMAND"
logger "# PROMPT_COMMAND ------------->  $PROMPT_COMMAND"
#logger "# PS1 ---------------------->  $PS1     "
# logger "# whoami ------------------->  $(whoami)"
logger "# tty ---------------------->  $(tty)   "
# logger "# echo \$? ------------------>  $(echo $?)   "
logger "# cat whereami --------------> $(cat /tmp/whereami)"
logger
exit

# ------------- CALLED ------------- #

# Notice on the next line, the first argument is called within double, 
# and single quotes, since it contains two words

$  /misc/shell_scripts/check_root/show_parms.sh "'hello there'" "'william'"

# ------------- RESULTS ------------- #

# arguments called with --->  'hello there' 'william'
# $1 ---------------------->  'hello there'
# $2 ---------------------->  'william'
# path to me -------------->  /misc/shell_scripts/check_root/show_parms.sh
# parent path ------------->  /misc/shell_scripts/check_root
# my name ----------------->  show_parms.sh

# ------------- END ------------- #

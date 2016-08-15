#!/bin/bash

# scrot -q 100 '/home/aj/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S_$wx$h.png' -e 's3cmd put -P $f s3://s3.j3ss.co/screenshots/ && echo https://s3.j3ss.co/screenshots/$n | xclip -i -selection clipboard'

# xinit /usr/X11R6/bin/xterm

#exec >/tmp/ss.$$.out
#exec 2>/tmp/ss.$$.err

source ~/.secrets/ss.aws

stamp=$(date +%F_%R)
filename="Screenshot_${stamp}.png"
path="/home/aj/Pictures/Screenshots/$filename"
url="ss.soulshake.net/$filename"

logger --id --tag "screenshot.sh" "scrotting: $filename"

scrot -q 100 $1 $path
msg="aws s3 cp --acl public-read $path s3://ss.soulshake.net # $url"

#echo $url | xclip -i -selection clipboard
echo $msg | xclip -i -selection clipboard 

#echo "ss.soulshake.net.s3-website.eu-central-1.amazonaws.com/$n"
#scrot -q 100 $1 '/home/aj/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H.%M.%S.png' -e 'aws s3 cp --acl public-read $f s3://ss.soulshake.net && echo ss.soulshake.net.s3-website.eu-central-1.amazonaws.com/$n'

logger --id --tag "screenshot.sh" "done scrotting: $url"

i3-nagbar -m "image url copied to clipboard: $url"
echo "done"

#/usr/share/command-not-found

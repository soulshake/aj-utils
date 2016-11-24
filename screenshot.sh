#!/bin/bash
# Take a screenshot, upload to s3 and copy the URL to the clipboard.
# Works when executed directly, but not when executed via i3 bindsym :(

source ~/.secrets/ss.aws

stamp=$(date +%F_%R)
filename="Screenshot_${stamp}.png"
path="/home/aj/Pictures/Screenshots/$filename"
url="ss.soulshake.net/$filename"

logger --id --tag "screenshot.sh" "scrotting: $filename"

scrot -q 100 "$path"
aws s3 cp --acl public-read $path s3://ss.soulshake.net # ss.soulshake.net/Screenshot_2016-11-02_22:33.png

msg="aws s3 cp --acl public-read $path s3://ss.soulshake.net"

echo $url | xclip -i -selection clipboard

logger --id --tag "screenshot.sh" "done scrotting: $url"

i3-nagbar -m "image url copied to clipboard: $url"

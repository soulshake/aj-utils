#!/bin/sh

curl -v -X PUT --digest -u "$CLOUDAPP_USER:$CLOUDAPP_PASS" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -H "Date: Tue, 15 Mar 2016 18:23:06 +0100" \
    -H "Authorization: AWS .... \
    -d $p1 -d $p2 -d $p3 -d $p4 -d $p5 -d $p6 -d $p7 \
    "http://s3.amazonaws.com/f.cl.ly"

# FML none of this works

# bucket="'http://s3.amazonaws.com/f.cl.ly'"
# resource="\"/${bucket}/${file}\""
# contentType="application/json"
# dateValue=`date -R`
# stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
# s3Key=
# signature=
# # signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64`
# echo curl -v -X PUT -T "${file}" \
  # -H "\"Host: ${bucket}"\" \
  # -H "\"Date: ${dateValue}"\" \
  # -H "\"Content-Type: ${contentType}"\" \
  # -H "\"Authorization: AWS ${s3Key}:${signature}"\" \
  # ${bucket}
  #https://${bucket}.s3.amazonaws.com/${file}

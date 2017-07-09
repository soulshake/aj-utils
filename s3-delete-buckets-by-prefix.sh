#!/bin/bash

BUCKET="$1"

for b in $(aws s3 ls | awk '{ print $3}' | sort | grep "^$BUCKET"); do
    #echo aws s3 rb "s3://$b" --region "$AWS_DEFAULT_REGION"
    echo aws s3api delete-bucket --bucket "$b"
    aws s3api delete-bucket --bucket "$b"
done


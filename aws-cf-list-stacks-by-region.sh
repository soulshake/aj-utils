#!/bin/bash

REGIONS="
ap-northeast-1
ap-southeast-1
ap-southeast-2
eu-central-1
eu-west-1
us-east-1
us-east-2
us-west-2
"

for r in $REGIONS; do
    echo "** Region: $r **"
    aws cloudformation describe-stacks --region "$r" --query "Stacks[*].StackId"
done

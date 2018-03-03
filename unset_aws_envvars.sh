#!/bin/bash
# This file must be *sourced* not executed

enumerate_aws_envvars() {
    AWS_ENVVARS="
        AWS
        AWS_ACCESS_KEY_ID
        AWS_DEFAULT_OUTPUT
        AWS_DEFAULT_PROFILE
        AWS_DEFAULT_REGION
        AWS_INSTANCE_TYPE
        AWS_LOGIN_URL
        AWS_PASSWORD
        AWS_REGION
        AWS_ACCESS_KEY
        AWS_SECRET_KEY
        AWS_S3_BUCKET
        AWS_S3_BUCKET_ENDPOINT
        AWS_S3_URI
        AWS_SECRET_ACCESS_KEY
        AWS_USER
        AWS_VPC_ID
    "
    echo "$AWS_ENVVARS"
}

unset_envvars() {
    for envvar in $(enumerate_aws_envvars); do
        if [ -z $envvar ]; then
            echo "$envvar not set"
        else
            #echo "unset $envvar"
            unset "$envvar"
        fi
    done
}

unset_envvars

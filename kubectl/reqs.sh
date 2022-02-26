#!/usr/bin/env bash

COLUMNS="NAMESPACE:.metadata.namespace,POD:.metadata.name,CONTAINER:.spec.containers[*].name"
COLUMNS="$COLUMNS,REQ_CPU:.spec.containers[*].resources.requests.cpu"
COLUMNS="$COLUMNS,LIM_CPU:.spec.containers[*].resources.limits.cpu"
COLUMNS="$COLUMNS,REQ_MEM:.spec.containers[*].resources.requests.memory"
COLUMNS="$COLUMNS,LIM_MEM:.spec.containers[*].resources.limits.memory"
COLUMNS="$COLUMNS,REQ_GPU:.spec.containers[*].resources.requests.nvidia\.com/gpu"
COLUMNS="$COLUMNS,LIM_GPU:.spec.containers[*].resources.limits.nvidia\.com/gpu"
COLUMNS="$COLUMNS,PHASE:.status.phase"
# COLUMNS="$COLUMNS,LIM_CPU:.spec.containers[*].resources.limits.cpu"

kubectl get pods -o custom-columns="$COLUMNS" "$@" | sed 's/<none>/-     /g'

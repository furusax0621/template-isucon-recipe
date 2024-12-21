#!/usr/bin/env bash

ROOT=$(git rev-parse --show-toplevel)
STACK_NAME=$1

set -ue

mkdir -p .cache
touch ".cache/${STACK_NAME}"

aws cloudformation validate-template \
    --template-body "file://${ROOT}/cloudformation/${STACK_NAME}.yaml" \
    --no-cli-pager

aws cloudformation deploy \
    --stack-name "${STACK_NAME}" \
    --template-file "${ROOT}/cloudformation/${STACK_NAME}.yaml" \
    --parameter-overrides "file://${ROOT}/cloudformation/parameters.json" \
    --capabilities CAPABILITY_IAM

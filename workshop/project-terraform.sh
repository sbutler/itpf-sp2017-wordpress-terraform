#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

action="$1"
if [[ -z $action ]]; then
    echo "Must specify the action as the first argument."
    exit 1
fi

project="$2"
if [[ -z $project ]]; then
    echo "Must specify the project name as the second argument."
    exit 1
fi

state_file="${SCRIPT_DIR}/tfstates/${project}.tfstate"
log_file="${SCRIPT_DIR}/logs/${project}.log"

export TF_INPUT=0

{
    case "$action" in
        destroy)
            terraform destroy -state "$state_file" -force
            ;;

        *)
            terraform "$action" -state "$state_file" -var "project=${project}"
            ;;
    esac
} 2>&1 | tee -a "$log_file" | sed -e "s/^/[${project}] /"

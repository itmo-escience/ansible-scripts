#!/usr/bin/env bash

function run {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo "error with $1. Exit status $status is not equal 0" >&2
        exit 1
    fi
    return $status
}

run ansible-playbook main.yml
run scp files/althosts 192.168.13.132:~/
run ssh 192.168.13.132 'bash -s' < files/run_dns.sh
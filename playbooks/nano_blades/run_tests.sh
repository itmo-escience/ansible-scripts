#!/usr/bin/env bash

cd ./test
vagrant up --no-provision
vagrant provision
cd ..
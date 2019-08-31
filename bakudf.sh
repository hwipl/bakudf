#!/bin/bash

PROJECT=$1
SIZE=$2

# create udf file for project
truncate -s "$SIZE" "$PROJECT".udf

# create udf file system in udf file
mkudffs --label="$PROJECT" "$PROJECT".udf

# mount udf file
sudo mkdir "$PROJECT"
sudo mount -t udf -o loop,rw "$PROJECT".udf "$PROJECT"

#/path/to/cdrecord -v -doa driveropts=burnfree \
#    dev=/dev/sr0 MYBLURAY-DISC.udf

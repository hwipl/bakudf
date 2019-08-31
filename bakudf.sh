#!/bin/bash

PROJECT=$1
SIZE=$2

# usage
if [[ "$#" -lt 2 ]]; then
	echo "Usage:"
	echo "    $0 <project> <size>"
	echo "Arguments:"
	echo "    project: name of the new project"
	echo "    size:    expected size of the project, e.g., 25GB, 5GB"
	exit
fi

# create udf file for project
truncate -s "$SIZE" "$PROJECT".udf

# create udf file system in udf file
mkudffs --label="$PROJECT" "$PROJECT".udf

# mount udf file
sudo mkdir "$PROJECT"
sudo mount -t udf -o loop,rw "$PROJECT".udf "$PROJECT"

#/path/to/cdrecord -v -doa driveropts=burnfree \
#    dev=/dev/sr0 MYBLURAY-DISC.udf

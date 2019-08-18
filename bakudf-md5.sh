#!/bin/bash

#truncate -s 25GB "$1".udf
#mkudffs "$1".udf
#
##mkudffs --media-type=dvd /tmp/cdimage.udf
#mkudffs --label="$1" "$1".udf
#
#sudo mkdir "$1"
#sudo mount -t udf -o loop,rw "$1".udf "$1"


if [[ "$1" == "create" ]]; then
	cd "$2"
	find . -type f -exec md5sum {} \;>> ../"$2".md5
fi

if [[ "$1" == "verify" ]]; then
	MD5DIR=$(pwd)
	cd "$3"
	echo "Verifying $2 in $3"
	md5sum -c "$MD5DIR"/"$2".md5
fi


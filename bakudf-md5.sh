#!/bin/bash

CMD=$1
DIR=$2
MD5=$3

# optional absolute path to a md5 file
if [[ -z "$MD5" ]]; then
	MD5=$(pwd)"/$DIR".md5
fi

# create a new md5 file for all files in a directory
if [[ "$CMD" == "create" ]]; then
	cd "$DIR" || exit
	find . -type f -exec md5sum {} \;>> ../"$DIR".md5
fi

# verify files in a directory with md5 file
if [[ "$CMD" == "verify" ]]; then
	cd "$DIR" || exit
	echo "Verifying $(pwd) with $MD5"
	md5sum -c "$MD5"
fi

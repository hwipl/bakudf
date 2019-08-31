#!/bin/bash

CMD=$1
DIR=$2
MD5=$3

# usage
if [[ "$#" -lt 2 ]]; then
	echo "Usage:"
	echo "$0 <create|verify> <dir> [md5]"
	echo "Arguments:"
	echo "    create: create a new md5 file for all files in \"dir\""
	echo "    verify: verify files in directory \"dir\" with md5 file"
	echo "    dir:    directory containing files for md5 file"
	echo "    md5:    absolute path to an alternative md5 file to verify"
	exit
fi

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

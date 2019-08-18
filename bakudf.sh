#!/bin/bash

#truncate -s 25GB "$1".udf
truncate -s 5GB "$1".udf
mkudffs "$1".udf

#mkudffs --media-type=dvd /tmp/cdimage.udf
mkudffs --label="$1" "$1".udf

sudo mkdir "$1"
sudo mount -t udf -o loop,rw "$1".udf "$1"


#/path/to/cdrecord -v -doa driveropts=burnfree \
#    dev=/dev/sr0 MYBLURAY-DISC.udf

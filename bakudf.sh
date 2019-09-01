#!/bin/bash

PROJECT=$1
SIZE=$2

# other program locations
TRUNCATE=/usr/bin/truncate
MKUDFFS=/usr/bin/mkudffs
MOUNT=/usr/bin/mount

# print usage
function print_usage {
	echo "Usage:"
	echo "    $0 <project> <size>"
	echo "Arguments:"
	echo "    project: name of the new project"
	echo "    size:    expected size of the project, e.g., 25GB, 5GB"
}

if [[ "$#" -lt 2 ]]; then
	print_usage
	exit
fi

# check if files/folders exist and abort in that case
FILES="$PROJECT.udf $PROJECT"
for i in $FILES; do
	if [[ -e "$i" ]]; then
		echo "$i already exists."
		exit
	fi
done

# create udf file for project
echo "Creating a new udf file: $PROJECT.udf"
$TRUNCATE -s "$SIZE" "$PROJECT".udf

# create udf file system in udf file
echo "Creating a new udf file system in $PROJECT.udf"
$MKUDFFS --label="$PROJECT" "$PROJECT".udf > /dev/null

# mount udf file
echo "Mounting $PROJECT.udf to the folder \"$PROJECT\""
mkdir "$PROJECT"
sudo $MOUNT -t udf -o loop,rw "$PROJECT".udf "$PROJECT"

# give further instructions
echo "Next steps:
* Copy all files to the folder \"$PROJECT\".
* Optional: create an md5 checksum file for the files in \"$PROJECT\" with
  ./bakudf-md5.sh create $PROJECT
  and copy \"$PROJECT.md5\" into the \"$PROJECT\" folder.
* Unmount the folder with \"umount $PROJECT\".
* Burn the udf file to a disc, e.g., with:
  cdrecord -v -doa driveropts=burnfree dev=/dev/sr0 $PROJECT.udf
  (Replace /dev/sr0 with the path to your device)."

#!/bin/bash

# other program locations
TRUNCATE=/usr/bin/truncate
MKUDFFS=/usr/bin/mkudffs
SUDO=/usr/bin/sudo
MOUNT=/usr/bin/mount
UMOUNT=/usr/bin/umount

# output text
STEPS_AFTER_CREATE="Next steps:
* Copy all files to the folder \"%s\".
* Optional: create an md5 checksum file for the files in \"%s\" with
  ./bakudf-md5.sh create %s
  and copy \"%s.md5\" into the \"%s\" folder."

STEPS_AFTER_FINALIZE="Next steps:
* Burn the udf file to a disc, e.g., with:
  cdrecord -v -doa driveropts=burnfree dev=/dev/sr0 %s.udf
  (Replace /dev/sr0 with the path to your device).
* You can remove the project folder \"%s\" and udf file \"%s.udf\""

# print usage
function print_usage {
	echo "Usage:"
	echo "    $0 <create> <project> <size>"
	echo "    $0 <finalize> <project>"
	echo "Arguments:"
	echo "    project: name of the new project"
	echo "    size:    expected size of the project, e.g., 25GB, 5GB"
}

# create new project
function create_project {
	# arguments
	PROJECT=$1
	SIZE=$2

	# check arguments
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
	$SUDO $MOUNT -t udf -o loop,rw "$PROJECT".udf "$PROJECT"

	# give further instructions
	echo "${STEPS_AFTER_CREATE//%s/$PROJECT}"
}

# finalize a project
function finalize_project {
	# arguments
	PROJECT=$1

	# check arguments
	if [[ "$#" -lt 1 ]]; then
		print_usage
		exit
	fi

	# umount udf file
	$SUDO $UMOUNT "$PROJECT"

	# give further instructions
	echo "${STEPS_AFTER_FINALIZE//%s/$PROJECT}"
}

if [[ "$1" == "create" ]]; then
	shift
	create_project "$@"
elif [[ "$1" == "finalize" ]]; then
	shift
	finalize_project "$@"
else
	print_usage
fi

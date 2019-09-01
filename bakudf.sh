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
* Optional: create md5 checksums for the files in \"%s\" with
  $0 md5 %s
* Finalize your project with:
  $0 finalize %s"

STEPS_AFTER_MD5_CREATE="Next steps:
* Optional: copy \"%s.md5\" into your project folder \"%s\".
* Finalize your project with:
  $0 finalize %s"

STEPS_AFTER_FINALIZE="Next steps:
* Burn the udf file to a disc, e.g., with:
  cdrecord -v -doa driveropts=burnfree dev=/dev/sr0 %s.udf
  (Replace /dev/sr0 with the path to your device).
* You can remove the project folder \"%s\" and udf file \"%s.udf\""

# print usage
function print_usage {
	echo "Usage:"
	echo "    $0 <create> <project> <size>"
	echo "    $0 <md5> <project> [create|verify]"
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

# run md5 commands
function run_md5 {
	# arguments
	PROJECT=$1
	CMD=$2

	# md5 file
	MD5=$(pwd)"/$PROJECT".md5

	# check arguments
	if [[ "$#" -lt 1 ]]; then
		print_usage
		exit
	fi

	# check if file already exists
	if [[ -e "$MD5" ]]; then
		echo "$MD5 already exists."
		exit
	fi

	# create a new md5 file for all files in a directory
	if [[ -z "$CMD" || "$CMD" == "create" ]]; then
		echo "Creating md5 checksums for \"$PROJECT\" in \"$MD5\""
		cd "$PROJECT" || exit
		find . -type f -exec md5sum {} \;>> "$MD5"

		# give further instruction
		echo "${STEPS_AFTER_MD5_CREATE//%s/$PROJECT}"
	fi

	# verify files in a directory with md5 file
	if [[ "$CMD" == "verify" ]]; then
		cd "$PROJECT" || exit
		echo "Verifying $(pwd) with $MD5"
		md5sum -c "$MD5"
	fi
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
elif [[ "$1" == "md5" ]]; then
	shift
	run_md5 "$@"
else
	print_usage
fi

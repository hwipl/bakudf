# bakudf

bakudf is a simple script that helps create udf file systems for backing up or
archiving data on blu-ray discs.

## Usage

*bakudf.sh* is the main script, that creates the udf file system and prints out
instructional text for the next steps:

```
Usage:
    ./bakudf.sh <project> <size>
Arguments:
    project: name of the new project
    size:    expected size of the project, e.g., 25GB, 5GB
```

bakudf creates an udf file system named `<project>.udf` and mounts it to a
subdirectory called `<project>`. Then, you can copy all files you want to
backup into that folder. Finally, you unmount the folder and write the udf file
to disc.

Additionally, there is the script *bakudf-md5.sh* for creating and verifying
md5 checksums of files in the project folder:

```
Usage:
    ./bakudf-md5.sh <create|verify> <dir> [md5]
Arguments:
    create: create a new md5 file for all files in "dir"
    verify: verify files in directory "dir" with md5 file
    dir:    directory containing files for md5 file
    md5:    absolute path to an alternative md5 file to verify
```

The script creates md5 checksums of all files in `<dir>` (e.g., your project
folder `<project>`) and writes them to a file called `<dir>.md5`. For example,
you can put this file into the udf file and write it to disc. Thus, you can
verify later if the files on the disc are uncorrupted.

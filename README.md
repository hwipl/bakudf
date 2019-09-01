# bakudf

bakudf is a simple script that helps create udf file systems for backing up or
archiving data, e.g., on blu-ray discs.

## Usage

*bakudf.sh* creates udf file systems, optional md5 checksums, and prints out
instructional text for the next steps:

```
bakudf - udf backup helper script

Usage:
    ./bakudf.sh <create> <project> <size>
    ./bakudf.sh <md5> <project> [create|verify]
    ./bakudf.sh <finalize> <project>
Arguments:
    create:   create a new project
    md5:      create (default) or verify md5 checksums for a project
    finalize: finalize a project
    project:  name of the new project
    size:     expected size of the project, e.g., 25GB, 5GB

First steps:
* Create a new project with
  ./bakudf.sh create <project> <size>
```

bakudf performs the following steps:
* `create`: bakudf creates an udf file system named `<project>.udf` with the
  size `<size>` and mounts it to a subdirectory called `<project>`. Then, you
  can copy all files you want to backup into that folder.
* `md5`: Optionally, bakudf creates md5 checksums of all files in your project
  folder `<project>` and writes them to a file called `<project>.md5`.  You can
  put this file into the udf file and write it to disc. Thus, you can verify
  later if the files on the disc are uncorrupted.
* `finalize`: Finally, bakudf unmounts the project folder, so you can write the
  udf file to disc.

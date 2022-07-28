# P4 Packages

This repository contains all files necessary to build packages for Ubuntu and Debian.

To build all debian packages run inside Ubuntu 20.04 container using Docker run the
following script:

```bash
./build.sh
```

## Build dependencies

Note that `build.sh` requires [Podman](https://podman.io/getting-started/installation.html) or [Docker](https://docs.docker.com/engine/install/) to be pre-installed.

# Ubuntu/Debian

Building a package for Ubuntu or Debian requires a number of files to be added in a subdirectory directory, called `debian`, in the source tree. These files can be used to build two types of packages: binary packages and source packages.

Binary packages contain executables, configuration files, man pages, copyright information, and other documentation. They can be installed on Ubuntu/Debian system with `dpkg` or `apt-get`.

In contrast, source packages contain the original unmodified source code in gzip-compressed tar format, a file describing the source package, and usually a file that contains changes to the original source. Source packages are used by automated build systems such as [Launchpad](https://launchpad.net/) and [Open Build Service](https://openbuildservice.org/).

## Building packages

The following commands can be used to build a Debian/Ubuntu package manually.

### Binary package

This command creates a `.deb` file.
```bash
dpkg-buildpackage -us -uc
```

### Source package

This command creates a source package for a new version of the source code file (`.orig.tar.gz`).
```bash
debuild -sa
```

### Source package update

This command creates an update for source package with an existing source code file (`.orig.tar.gz`).
```bash
debuild -sd
```

## Files under the `debian` directory

### `control`

This file contains [control information](https://www.debian.org/doc/debian-policy/ch-controlfields.html) used by package management tools.

### `rules`

This is an executable Makefile that is used to create the package. Like any other Makefile, it consists of several rules, each of which defines a target and how it is carried out.

### `changelog`

This file contains a brief explanation of changes and updates to the package.

### `copyright`

This file contains information about the copyright and license of the upstream sources.

### `compat`

This file specifies the [compatibility level](https://manpages.debian.org/bullseye/debhelper/debhelper.7.en.html#COMPATIBILITY_LEVELS) for the [debhelper](https://packages.debian.org/search?keywords=debhelper) tool.

### `source/format`

This file contains the version number for the format of the source package.

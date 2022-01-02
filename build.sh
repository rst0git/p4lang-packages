#!/bin/bash

set -e

docker build -t p4lang-packages .

mkdir -p build/

for target in pi bmv2 p4c; do
    docker run \
        --rm \
        --storage-opt size=25G \
        --mount type=bind,source="$(pwd)/build",target=/mnt \
        p4lang-packages \
        bash -c "make ${target}-sdeb && dpkg -c *.deb && mv *.build *.buildinfo *.changes *.deb *.debian.tar.xz *.dsc *.orig.tar.gz /mnt";
done

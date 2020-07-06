#!/bin/bash

set -euo pipefail

env | grep -e "^INPUT"

version=${INPUT_VERSION##*v}
debchange -v ${version} -D stable -m "Release v${version}"
export GOPROXY="https://goproxy.io,direct"
dpkg-buildpackage --host-arch ${INPUT_HOSTARCH} -uc -us -b -d

mkdir build
mv -v ../*.deb build
asset_path=$(ls build/*.deb)
echo "::set-output name=asset_name::${asset_path##*/}"
echo "::set-output name=asset_path::${asset_path}"

exit 0

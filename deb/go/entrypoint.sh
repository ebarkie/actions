#!/bin/bash

set -euo pipefail

env | grep -e "^INPUT"

version=${INPUT_VERSION##*v}
debchange -v ${version} -D stable -m "Release v${version}"
git config --global --add safe.directory /github/workspace
git update-index --assume-unchanged debian/changelog
export GOPROXY="direct"
dpkg-buildpackage --host-arch ${INPUT_HOSTARCH} -uc -us -b -d

mkdir build
mv -v ../*.deb build
asset_path=$(ls build/*.deb)
echo "asset_name=${asset_path##*/}" >> ${GITHUB_OUTPUT}
echo "asset_path=${asset_path}" >> ${GITHUB_OUTPUT}

exit 0

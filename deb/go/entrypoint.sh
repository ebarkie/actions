#!/bin/bash

set -euo pipefail

env | grep -e "^INPUT"

debchange -v ${INPUT_VERSION#"v"} -D stable -m "Release ${INPUT_VERSION}"
export GOPROXY="https://goproxy.io,direct"
dpkg-buildpackage --host-arch ${INPUT_HOSTARCH} -uc -us -b -d

asset_name=$(basename $(ls ../station-uploader_*_${INPUT_HOSTARCH}.deb))
echo "::set-output name=asset_name::$asset_name"
echo "::set-output name=asset_path::../$asset_name"

exit 0

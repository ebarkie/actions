#!/bin/bash

set -euo pipefail

env | grep -e "^INPUT"

version=${INPUT_VERSION#"refs/tags/v"}
debchange -v ${version} -D stable -m "Release v${version}"
export GOPROXY="https://goproxy.io,direct"
dpkg-buildpackage --host-arch ${INPUT_HOSTARCH} -uc -us -b -d

asset_name=$(basename $(ls ../station-uploader_*_${INPUT_HOSTARCH}.deb))
echo "::set-output name=asset_name::$asset_name"
echo "::set-output name=asset_path::../$asset_name"

exit 0

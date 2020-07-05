#!/bin/bash

set -euo pipefail

env | grep -e "^INPUT"

export GOPROXY="https://goproxy.io,direct"
dpkg-buildpackage --host-arch $INPUT_HOSTARCH -uc -us -b

asset_name="$(basename $GITHUB_REPOSITORY)_0.1-1_$INPUT_HOSTARCH.deb"
echo "::set-output name=asset_name::$asset_name"
echo "::set-output name=asset_path::../$asset_name"

exit 0

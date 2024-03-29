#!/bin/bash

set -euo pipefail

env | grep -e "^INPUT" -e "^GO"

apt_install() {
    local pkgs="$1"

    echo "*** apt installing: $pkgs"
    apt-get update && apt-get install --no-install-recommends -y $pkgs
}

asset() {
    echo "${GITHUB_REPOSITORY##*/}-$GOOS-$GOARCH"
}

asset_bin() {
    case $GOOS in
    windows)
        echo "build/$(asset).exe"
        ;;
    *)
        echo "build/$(asset)"
        ;;
    esac
}

asset_name() {
    echo "$(asset).zip"
}

asset_path() {
    echo "build/$(asset_name)"
}

build_asset() {
    echo "*** Build asset"
    zip -j $(asset_path) $(asset_bin) LICENSE

    echo "::set-output name=asset_name::$(asset_name)"
    echo "::set-output name=asset_path::$(asset_path)"
}

go_build() {
    echo "*** Go build"
    go build -o $(asset_bin)
}

go_fmt() {
    echo "*** Go format"
    go fmt ./...
}

go_generate() {
    echo "*** Go generate"
    git config --global --add safe.directory /github/workspace
    go generate -x ./...
}

go_install() {
    local pkgs="$1"

    echo "*** Go install"
    go install $pkgs
}

go_mod_download() {
    echo "*** Go module download"
    go mod download
}

go_test() {
    echo "*** Go test"
    go test -race -v $(go list ./... | grep -v /examples)
}

go_vet() {
  echo "*** Go vet"
  go vet $(go list ./... | grep -v /examples)
}

[ "$INPUT_APT_INSTALL" = "" ] || apt_install "$INPUT_APT_INSTALL"
[ "$INPUT_INSTALL" = "" ] || go_install "$INPUT_INSTALL"
go_mod_download
go_generate
if [ "$GOOS" = "linux" ] && [ "$GOARCH" = "amd64" ]; then
    [ "$INPUT_FMT" = "true" ] && go_fmt
    [ "$INPUT_VET" = "true" ] && go_vet
    [ "$INPUT_TEST" = "true" ] && go_test
fi
[ "$INPUT_BUILD" = "true" ] || [ "$INPUT_BUILD_ASSET" = "true" ] && go_build
[ "$INPUT_BUILD_ASSET" = "true" ] && build_asset

exit 0

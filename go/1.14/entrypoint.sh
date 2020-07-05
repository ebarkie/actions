#!/bin/bash

set -euo pipefail

echo "GITHUB_REPOSITORY=$GITHUB_REPOSITORY"
echo "GOOS=$GOOS"
echo "GOARCH=$GOARCH"

apt_add() {
    local pkgs="$1"

    echo "*** Installing additional packages: $pkgs"
    apt-get update && apt-get install --no-install-recommends -y $pkgs
}

asset() {
    echo "$(basename $GITHUB_REPOSITORY)-$GOOS-$GOARCH"
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

go_build() {
    local build_asset="$1"

    echo "*** Go build" 
    go build -o $(asset_bin)

    if [ "$build_asset" = "true" ]; then
        zip -j $(asset_path) $(asset_bin) LICENSE
        echo "::set-output name=asset_name::$(asset_name)"
        echo "::set-output name=asset_path::$(asset_path)"
    fi
}

go_fmt() {
    echo "*** Go format"
    go fmt ./...
}

go_generate() {
    echo "*** Go generate"
    go generate -x ./...
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

[ "$INPUT_APT_ADD" = "" ] || apk_add "$INPUT_APT_ADD"
go_mod_download
go_generate

if [ "$GOOS" = "linux" ] && [ "$GOARCH" = "amd64" ]; then
    [ "$INPUT_FMT" = "true" ] && go_fmt
    [ "$INPUT_VET" = "true" ] && go_vet
    [ "$INPUT_TEST" = "true" ] && go_test
fi

[ "$INPUT_BUILD" = "true" ] && go_build "$INPUT_BUILD_ASSET"

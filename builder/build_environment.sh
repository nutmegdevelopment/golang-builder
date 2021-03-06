#!/bin/bash

tagName=$1

if ( find /src -maxdepth 0 -empty | read v );
then
  echo "Error: Must mount Go source code into /src directory"
  exit 990
fi

# Grab Go package name
pkgName="$(go list -e -f '{{.ImportComment}}' 2>/dev/null || true)"

if [ -z "$pkgName" ];
then
  echo "Error: Must add canonical import path to root package"
  exit 992
fi

# Grab just first path listed in GOPATH
goPath="${GOPATH%%:*}"

# Construct Go package path
pkgPath="$goPath/src/$pkgName"

# Set-up src directory tree in GOPATH
mkdir -p "$(dirname "$pkgPath")"

# Link source dir into GOPATH
ln -sf /src "$pkgPath"

if [ -e "$pkgPath/vendor" ];
then
    echo "Using vendor packages..."
elif [ -f "$pkgPath/Gopkg.lock" ];
then
    echo "Using dep package lock files to get dependencies"
    go get -u github.com/golang/dep/cmd/dep

    cd "$pkgPath" || exit 1

    dep ensure -v

elif [ -e "$pkgPath/Godeps/_workspace" ];
then
  # Add local godeps dir to GOPATH
  GOPATH=$pkgPath/Godeps/_workspace:$GOPATH
else
  # Get all package dependencies
  go get -t -d -v ./...
fi
